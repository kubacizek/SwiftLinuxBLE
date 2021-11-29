import Foundation
import Bluetooth
import GATT
import BluetoothLinux

@available(OSX 10.12, *)
extension HostController {
    public func newPeripheral() throws -> GATTPeripheral<HostController, L2CAPSocket> {
        // Setup peripheral
        let address = try readDeviceAddress()
        let serverSocket = try L2CAPSocket.lowEnergyServer(address: address, isRandom: false)
        
        let peripheral = GATTPeripheral<HostController, L2CAPSocket>(controller: self)
        peripheral.newConnection = {
           let socket = try serverSocket.accept()
           let central = Central(identifier: socket.address.address)
           return (socket, central)
        }
        return peripheral
    }
}
