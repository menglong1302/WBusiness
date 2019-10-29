//
//  Permission.swift
//  YLImagePicker
//
//  Created by YangXL on 2017/10/23.
//  Copyright © 2017年 LYL. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

struct YLPermission {
    enum Status {
        case notDetermined
        case restricted
        case denied
        case authorized
    }
    struct Photos {
        static var status: Status {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorized:
                return .authorized
            }
        }
        static func request(_ completion: @escaping () -> Void) {
            PHPhotoLibrary.requestAuthorization { status in
                completion()
            }
        }
    }
    struct Camera {
        static var status: Status {
            switch AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeVideo) {
            case .notDetermined:
                return .notDetermined
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorized:
                return .authorized
            }
        }
        
        static func request(_ completion: @escaping () -> Void) {
            AVCaptureDevice.requestAccess(forMediaType:AVMediaTypeVideo) { granted in
                completion()
            }
        }
    }
}
