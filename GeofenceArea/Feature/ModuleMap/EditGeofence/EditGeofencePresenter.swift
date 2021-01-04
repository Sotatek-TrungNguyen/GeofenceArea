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
    @discardableResult func loadGeofence() -> GeofenceModel?
}

public class EditGeofencePresenter: IEditGeofencePresenter {
    
    private weak var view: IEditGeofenceView?
    private let service: IGeofenceAreaService
    
    init(service: IGeofenceAreaService) {
        self.service = service
    }
    
    public func onViewDidLoad(view: IEditGeofenceView) {
        self.view = view
    }
    
    @discardableResult
    public func loadGeofence() -> GeofenceModel?{
        guard let geofence = service.getGeofence() else { return nil}
        self.view?.updateUIWithModel(geofence)
        return geofence
    }
}
