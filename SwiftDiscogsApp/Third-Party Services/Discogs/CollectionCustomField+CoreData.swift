//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import SwiftDiscogs

public extension CustomField {

    class func fetchOrCreateEntity(fromDiscogsField discogsField: CollectionCustomField,
                                   inContext context: NSManagedObjectContext) throws -> CustomField? {
        let predicate = NSPredicate(format: "id = \(discogsField.id)")
        let sortByID = (\CustomField.id).sortDescriptor()
        var entity: CustomField? = nil

        if discogsField.type == CollectionCustomField.FieldType.dropdown.rawValue {
            let fetchRequest = CustomDropdownField.fetchRequest(sortDescriptors: [sortByID],
                                                                predicate: predicate)
            let dropdownEntity = try context.fetch(fetchRequest).first as? CustomDropdownField
                ?? CustomDropdownField(context: context)
            dropdownEntity.values = discogsField.options?.joined(separator: "|")
            entity = dropdownEntity
        } else {
            let fetchRequest = CustomTextAreaField.fetchRequest(sortDescriptors: [sortByID],
                                                                predicate: predicate)
            let textAreaEntity = try context.fetch(fetchRequest).first as? CustomTextAreaField
                ?? CustomTextAreaField(context: context)
            textAreaEntity.lines = Int16(discogsField.lines ?? 1)
            entity = textAreaEntity
        }

        entity?.isPublic = discogsField.public
        entity?.name = discogsField.name
        entity?.position = Int16(discogsField.position)
        entity?.id = Int16(discogsField.id)

        return entity
    }

}
