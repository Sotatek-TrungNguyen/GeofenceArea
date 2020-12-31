//
//  EditGeofencePresenter.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation

public protocol IEditGeofencePresenter {
    func loadGeofence()
}

public class EditGeofencePresenter: IEditGeofencePresenter {
    
    private weak var view: IEditGeofenceView?
    private let service: IGeofenceAreaService
    
    init(view: IEditGeofenceView, service: IGeofenceAreaService) {
        self.view = view
        self.service = service
    }
    
    public func loadGeofence() {
        guard let geofence = service.getGeofence() else { return }
        self.view?.updateUIWithModel(geofence)
    }
}
