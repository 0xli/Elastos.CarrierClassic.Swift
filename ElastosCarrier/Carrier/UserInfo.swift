/*
 * Copyright (c) 2018 Elastos Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import Foundation

/**
 A class representing the Carrier user information.
 
 In Elastos carrier SDK, self and all friends are carrier user, and have
 same user attributes.
 */
@objc(ELACarrierUserInfo)
public class CarrierUserInfo: NSObject {
    
    /// Elastos carrier User ID max length.
    @objc public static let MAX_ID_LEN: Int = 45
    
    /// Elastos carrier user name max length.
    @objc public static let MAX_USER_NAME_LEN: Int = 63
    
    /// Elastos carrier user description max length.
    @objc public static let MAX_USER_DESCRIPTION_LEN: Int = 127
    
    /// Elastos carrier user gender max length.
    @objc public static let MAX_GENDER_LEN: Int = 31
    
    /// Elastos carrier user phone number max length.
    @objc public static let MAX_PHONE_LEN: Int = 31
    
    /// Elastos carrier user email address max length.
    @objc public static let MAX_EMAIL_LEN: Int = 127
    
    /// Elastos carrier user region max length.
    @objc public static let MAX_REGION_LEN: Int = 127
    
    internal override init() {
        self.hasAvatar = false
        super.init()
    }
    
    /**
     User ID.
     */
    @objc public internal(set) var userId: String?
    
    /**
     Nickname, also as display name.
     */
    @objc public var name: String?
    
    /**
     User's brief description, also as what's up.
     */
    @objc public var briefDescription: String?
    
    /**
     If user has avatar.
     */
    @objc public var hasAvatar: Bool
    
    /**
     User's gender.
     */
    @objc public var gender: String?
    
    /**
     User's phone number.
     */
    @objc public var phone: String?
    
    /**
     User's email address.
     */
    @objc public var email: String?
    
    /**
     User's region information.
     */
    @objc public var region: String?
    
    internal static func format(_ info: CarrierUserInfo) -> String {
        return String(format: "userId[%@], name[%@], briefDescription[%@]," +
            "hasAvatar[%@], gender[%@], phone[%@]" +
            "email[%@], region[%@]",
                      String.toHardString(info.userId),
                      String.toHardString(info.name),
                      String.toHardString(info.briefDescription),
                      String.toHardString(info.hasAvatar.description),
                      String.toHardString(info.gender),
                      String.toHardString(info.phone),
                      String.toHardString(info.email),
                      String.toHardString(info.region))
    }
    
    public override var description: String {
        return CarrierUserInfo.format(self)
    }
}

internal func convertCarrierUserInfoToCUserInfo(_ info: CarrierUserInfo) -> CUserInfo {
    var cInfo = CUserInfo()
    
    info.userId?.writeToCCharPointer(&cInfo.userid)
    info.name?.writeToCCharPointer(&cInfo.name)
    info.briefDescription?.writeToCCharPointer(&cInfo.description)
    info.gender?.writeToCCharPointer(&cInfo.gender)
    info.phone?.writeToCCharPointer(&cInfo.phone)
    info.email?.writeToCCharPointer(&cInfo.email)
    info.region?.writeToCCharPointer(&cInfo.region)
    
    cInfo.has_avatar = Int32(info.hasAvatar ? 1: 0)
    
    return cInfo
}

internal func convertCUserInfoToCarrierUserInfo(_ cInfo: CUserInfo) -> CarrierUserInfo {
    let info = CarrierUserInfo()
    var temp = cInfo
    
    info.userId = String(cCharPointer: &temp.userid)
    info.name = String(cCharPointer: &temp.name)
    info.briefDescription = String(cCharPointer: &temp.description)
    info.gender = String(cCharPointer: &temp.gender)
    info.phone = String(cCharPointer: &temp.phone)
    info.email = String(cCharPointer: &temp.email)
    info.region = String(cCharPointer: &temp.region)
    
    info.hasAvatar = (cInfo.has_avatar != 0)
    
    return info
}

// MARK: - AgentNet proto v2

/// What a Carrier client advertises to its friends (AgentNet client metadata).
///
/// `protoVersion` follows the JavaScript peer's definition: 0 legacy, 1 client
/// metadata + 16 MB bulk messages, 2 = the *application* answers DNPACK1 text
/// delivery ACKs. The SDK advertises 1 by itself; an app sets 2 only if it
/// implements the ACK, because a peer that sees 2 keeps re-sending each text
/// until the app acknowledges it.
@objc(ELACarrierClientInfo)
public class CarrierClientInfo: NSObject {
    @objc public var protoVersion: UInt32 = 0
    /// "ios" | "android" | "js" | "darwin" | "linux" | "win32"
    @objc public var platform: String = ""
    @objc public var osVersion: String = ""
    @objc public var appVersion: String = ""

    public override init() { super.init() }

    @objc public convenience init(protoVersion: UInt32, platform: String, osVersion: String, appVersion: String) {
        self.init()
        self.protoVersion = protoVersion
        self.platform = platform
        self.osVersion = osVersion
        self.appVersion = appVersion
    }

    public override var description: String {
        "clientInfo[proto \(protoVersion), \(platform) \(osVersion), \(appVersion)]"
    }
}

internal func convertCarrierClientInfoToCClientInfo(_ info: CarrierClientInfo) -> CClientInfo {
    var c = CClientInfo()
    c.proto_version = info.protoVersion
    info.platform.writeToCCharPointer(&c.platform)
    info.osVersion.writeToCCharPointer(&c.os_version)
    info.appVersion.writeToCCharPointer(&c.app_version)
    return c
}

internal func convertCClientInfoToCarrierClientInfo(_ c: CClientInfo) -> CarrierClientInfo {
    var temp = c
    let info = CarrierClientInfo()
    info.protoVersion = c.proto_version
    info.platform = String(cCharPointer: &temp.platform)
    info.osVersion = String(cCharPointer: &temp.os_version)
    info.appVersion = String(cCharPointer: &temp.app_version)
    return info
}

// MARK: - AgentNet proto v2

/// The profile extension a Carrier identity publishes in its userinfo
/// (AgentNet): pointers, never bytes — the app fetches the avatar itself.
/// Every field is optional; the whole userinfo must fit toxcore's 1007-byte
/// status message, so `Carrier.setSelfProfileExt` can refuse a long profile.
@objc(ELACarrierProfileExt)
public class CarrierProfileExt: NSObject {
    /// https URL of an avatar image (max 255 bytes)
    @objc public var avatarUrl: String = ""
    /// a personal / site link (max 255 bytes)
    @objc public var url: String = ""
    /// "<name>.beagles.eth" — a display hint, not proof (max 63 bytes)
    @objc public var ens: String = ""
    /// small JSON for forward growth (max 255 bytes)
    @objc public var extra: String = ""

    public override init() { super.init() }

    @objc public convenience init(avatarUrl: String, url: String, ens: String, extra: String) {
        self.init()
        self.avatarUrl = avatarUrl
        self.url = url
        self.ens = ens
        self.extra = extra
    }

    public override var description: String {
        "profileExt[avatar \(avatarUrl), url \(url), ens \(ens), extra \(extra)]"
    }
}

internal func convertCarrierProfileExtToCProfileExt(_ ext: CarrierProfileExt) -> CProfileExt {
    var c = CProfileExt()
    ext.avatarUrl.writeToCCharPointer(&c.avatar_url)
    ext.url.writeToCCharPointer(&c.url)
    ext.ens.writeToCCharPointer(&c.ens)
    ext.extra.writeToCCharPointer(&c.extra)
    return c
}

internal func convertCProfileExtToCarrierProfileExt(_ c: CProfileExt) -> CarrierProfileExt {
    var temp = c
    let ext = CarrierProfileExt()
    ext.avatarUrl = String(cCharPointer: &temp.avatar_url)
    ext.url = String(cCharPointer: &temp.url)
    ext.ens = String(cCharPointer: &temp.ens)
    ext.extra = String(cCharPointer: &temp.extra)
    return ext
}
