import Foundation

typealias MRGetInfoFunc = @convention(c) (DispatchQueue, @escaping (CFDictionary?) -> Void) -> Void

if let handle = dlopen("/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote", RTLD_NOW),
   let getInfoSym = dlsym(handle, "MRMediaRemoteGetNowPlayingInfo") {
    let getNowPlayingInfo = unsafeBitCast(getInfoSym, to: MRGetInfoFunc.self)
    let semaphore = DispatchSemaphore(value: 0)

    getNowPlayingInfo(DispatchQueue.global()) { dict in
        defer { semaphore.signal() }
        guard let info = dict as? [String: Any],
              let rate = (info["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? NSNumber)?.doubleValue,
              rate > 0,
              let title = info["kMRMediaRemoteNowPlayingInfoTitle"] as? String, !title.isEmpty
        else {
            print("NO_MEDIA")
            return
        }

        let artist = info["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? ""
        print(artist.isEmpty ? title : "\(title) - \(artist)")
    }
    
    _ = semaphore.wait(timeout: .now() + 0.2)
} else {
    print("NO_MEDIA")
}
