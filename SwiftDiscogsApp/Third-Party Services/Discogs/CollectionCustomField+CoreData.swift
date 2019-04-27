//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreData
import SwiftDiscogs

public extension CollectionCustomField {

    func fetchOrCreateEntity(inContext context: NSManagedObjectContext) throws -> CustomField? {
        let predicate = NSPredicate(format: "id = \(self.id)")
        let sortByID = (\CustomField.id).sortDescriptor()
        var entity: CustomField? = nil

        if self.type == CollectionCustomField.FieldType.dropdown.rawValue {
            let fetchRequest = CustomDropdownField.fetchRequest(sortDescriptors: [sortByID],
                                                                predicate: predicate)
            let dropdownEntity = try context.fetch(fetchRequest).first as? CustomDropdownField
                ?? CustomDropdownField(context: context)
            dropdownEntity.values = self.options?.joined(separator: "|")
            entity = dropdownEntity
        } else {
            let fetchRequest = CustomTextAreaField.fetchRequest(sortDescriptors: [sortByID],
                                                                predicate: predicate)
            let textAreaEntity = try context.fetch(fetchRequest).first as? CustomTextAreaField
                ?? CustomTextAreaField(context: context)
            textAreaEntity.lines = Int16(self.lines ?? 1)
            entity = textAreaEntity
        }

        entity?.isPublic = self.public
        entity?.name = self.name
        entity?.position = Int16(self.position)
        entity?.id = Int16(self.id)

        return entity
    }

}
