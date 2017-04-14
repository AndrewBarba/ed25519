import CEd25519

public final class PublicKey {
    let buffer: [UInt8]
    
    public init(_ buffer: [UInt8]) throws {
        guard buffer.count == 32 else {
            throw Ed25519Error.invalidPublicKeyLength
        }
        
        self.buffer = buffer
    }
    
    init(unchecked buffer: [UInt8]) {
        self.buffer = buffer
    }
    
    public func verify(signature: [UInt8], message: [UInt8]) -> Bool {
        return signature.withUnsafeBufferPointer { signature in
            message.withUnsafeBufferPointer { msg in
                buffer.withUnsafeBufferPointer { pub in
                    ed25519_verify(signature.baseAddress,
                                   msg.baseAddress,
                                   message.count,
                                   pub.baseAddress) == 1
                }
            }
        }
    }
}