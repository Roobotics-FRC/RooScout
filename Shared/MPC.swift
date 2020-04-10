//
//  MPC.swift
//  RooScout
//
//  Created by @Samasaur1 on 4/10/20.
//  Copyright © 2020 AFS RooBotics. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import Combine

class MPC: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    static let shared = MPC()

    private override init() {}

    deinit {
        self.disconnect()
    }

    var debug = false
    private func dprint(_ item: Any, terminator: String = "\n") {
        guard debug else { return }
        print(item, terminator: terminator)
    }

    fileprivate(set) var serviceType: String!

    fileprivate(set) var myPeerID: MCPeerID!

    var timeout = 10.0

    fileprivate var serviceAdvertiser: MCNearbyServiceAdvertiser!
    fileprivate var serviceBrowser: MCNearbyServiceBrowser!

    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()

    func initialize(serviceType: String) {
        #if os(iOS)
        initialize(serviceType: serviceType, deviceName: UIDevice.current.name)
        #elseif os(macOS)
        initialize(serviceType: serviceType, deviceName: Host.current().localizedName!)
        #endif
    }

    func initialize(serviceType: String, deviceName: String) {
        // Setup device/session properties
        self.serviceType = serviceType
        self.myPeerID = MCPeerID(displayName: deviceName)

        // Setup the service advertiser
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: self.myPeerID,
                                                           discoveryInfo: nil,
                                                           serviceType: serviceType)
        self.serviceAdvertiser.delegate = self

        // Setup the service browser
        self.serviceBrowser = MCNearbyServiceBrowser(peer: self.myPeerID,
                                                     serviceType: serviceType)
        self.serviceBrowser.delegate = self
    }

    var isHosting: Bool = false
    var isSearching: Bool = false

    func startHosting() {
        self.serviceBrowser.startBrowsingForPeers()
        isHosting = true
    }

    func startSearching() {
        self.serviceAdvertiser.startAdvertisingPeer()
        isSearching = true
    }

    func stopHosting() {
        self.serviceBrowser.stopBrowsingForPeers()
        isHosting = false
    }

    func stopSearching() {
        self.serviceAdvertiser.stopAdvertisingPeer()
        isSearching = false
    }

    func stopNewConnections() {
        stopSearching()
        stopHosting()
    }

    func disconnect() {
        session.disconnect()
    }

    #if os(macOS)
    func disconnect(_ peer: MCPeerID) {
        send(Data(repeating: 0, count: 1), to: peer)
    }
    #endif

    func end() {
        stopNewConnections()
        disconnect()
    }

    var isConnected: Bool {
        return session.connectedPeers.count > 0
    }

    func send(_ data: Data, to peers: MCPeerID...) {
        send(data, to: peers)
    }

    func send(_ data: Data, to peers: [MCPeerID]) {
        do {
            try session.send(data, toPeers: peers, with: .reliable)
        } catch let err {
            print(err.localizedDescription)
        }
    }

    func send(_ data: Data) {
        send(data, to: session.connectedPeers)
    }

    //MARK: - MCSessionDelegate

    var statePublisher: PassthroughSubject<(MCPeerID, MCSessionState), Never> = PassthroughSubject()
    var dataPublisher: PassthroughSubject<(MCPeerID, Data), Never> = PassthroughSubject()

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        statePublisher.send((peerID, state))
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        dataPublisher.send((peerID, data))
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        dprint(#function)
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        dprint(#function)
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        dprint(#function)
    }

    //MARK: - MCNearbyServiceAdvertiserDelegate

    var invitationPublisher: PassthroughSubject<(MCPeerID, Data?, (Bool) -> Void), Never> = PassthroughSubject()

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationPublisher.send((peerID, context, { join in
            invitationHandler(join, self.session)
        }))
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        dprint(#function + "\n" + error.localizedDescription)
    }

    //MARK: - MCNearbyServiceBrowserDelegate

    var availablePeerPublisher: PassthroughSubject<(MCPeerID, [String: String]?, (Bool) -> Void), Never> = PassthroughSubject()
    var lostPeerPublisher: PassthroughSubject<MCPeerID, Never> = PassthroughSubject()

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        availablePeerPublisher.send((peerID, info, { accept in
            guard accept else { return }
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: self.timeout)
        }))
    }

    #if os(macOS)
    func add(peer: MCPeerID) {
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: self.timeout)
    }
    #endif

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        lostPeerPublisher.send(peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        dprint(#function + "\n" + error.localizedDescription)
    }
}
