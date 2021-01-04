//
//  EditGeofencePresenter.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/31/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import Foundation

public protocol IEditGeofencePresenter {
    func onViewDidLoad(view: IEditGeofenceView)
    func loadGeofence()
}

public class EditGeofencePresenter: IEditGeofencePresenter {
    
    private weak var view: IEditGeofenceView?
    private let service: IGeofenceAreaService
    
    init(service: IGeofenceAreaService) {
        self.service = service
    }
    
    public func onViewDidLoad(view: IEditGeofenceView) {
        self.view = view
        // Update UI when have geofence before
        self.loadGeofence()
    }
    
    public func loadGeofence() {
        guard let geofence = service.getGeofence() else { return }
        self.view?.updateUIWithModel(geofence)
    }
}
