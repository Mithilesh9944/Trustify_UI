// File: util_product_form.dart
import 'package:flutter/cupertino.dart';

enum CategoryGroup {
  vehicle,
  furniture,
  electronics,
  books,
  homeappliance,
}

enum SubCategory {
  car,
  bike,
  cycle,
  furniture,
  mobile,
  laptop,
  book,
  washingMachine,
  refrigerator,
  airConditioner,
}

enum FormFieldType {
  text,
  dropdown,
  description,
}

class UtilProductForm {
  static Map<CategoryGroup, Map<SubCategory, Map<String, List<Map<String, dynamic>>>>> formCategories = {
    CategoryGroup.vehicle: {
      SubCategory.bike: {
        "Bike Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["Honda", "Yamaha", "Suzuki"]},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Fuel Type", "type": FormFieldType.dropdown, "options": ["Petrol", "Electric"]},
          {"label": "Km Driven", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Owner", "type": FormFieldType.dropdown, "options": ["1st", "2nd", "3rd"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      },
      SubCategory.car: {
        "Car Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["Hyundai", "Toyota", "Ford"]},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Fuel Type", "type": FormFieldType.dropdown, "options": ["Petrol", "Diesel"]},
          {"label": "Transmission", "type": FormFieldType.dropdown, "options": ["Manual", "Automatic"]},
          {"label": "Km Driven", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Owner", "type": FormFieldType.dropdown, "options": ["1st", "2nd", "3rd"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      },
      SubCategory.cycle: {
        "Cycle Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["Hero", "Hercules", "BSA"]},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.electronics: {
      SubCategory.mobile: {
        "Mobile Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["Apple", "Samsung", "OnePlus"]},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "RAM", "type": FormFieldType.dropdown, "options": ["4GB", "6GB", "8GB"]},
          {"label": "Storage", "type": FormFieldType.dropdown, "options": ["64GB", "128GB", "256GB"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      },
      SubCategory.laptop: {
        "Laptop Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["Dell", "HP", "Apple"]},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "RAM", "type": FormFieldType.dropdown, "options": ["8GB", "16GB", "32GB"]},
          {"label": "Storage", "type": FormFieldType.dropdown, "options": ["256GB", "512GB", "1TB"]},
          {"label": "Processor", "type": FormFieldType.dropdown, "options": ["i5", "i7", "M1"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.books: {
      SubCategory.book: {
        "Book Details": [
          {"label": "Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Genre", "type": FormFieldType.dropdown, "options": ["Fantasy", "Mystery", "Adventure"]},
          {"label": "Author", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Year", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.furniture: {
      SubCategory.furniture: {
        "Furniture Details": [
          {"label": "Type", "type": FormFieldType.dropdown, "options": ["Chair", "Table", "Sofa"]},
          {"label": "Material", "type": FormFieldType.dropdown, "options": ["Wood", "Metal"]},
          {"label": "Condition", "type": FormFieldType.dropdown, "options": ["New", "Used"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.homeappliance: {
      SubCategory.washingMachine: {
        "Appliance Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["LG", "Samsung"]},
          {"label": "Capacity", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "type": FormFieldType.dropdown, "options": ["Top Load", "Front Load"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      },
      SubCategory.refrigerator: {
        "Appliance Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["LG", "Samsung", "Whirlpool"]},
          {"label": "Capacity (L)", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "type": FormFieldType.dropdown, "options": ["Single Door", "Double Door"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      },
      SubCategory.airConditioner: {
        "Appliance Details": [
          {"label": "Brand", "type": FormFieldType.dropdown, "options": ["LG", "Samsung", "Daikin"]},
          {"label": "Capacity (Ton)", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "type": FormFieldType.dropdown, "options": ["Window AC", "Split AC"]},
          {"label": "Ad Title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "type": FormFieldType.description}
        ]
      }
    },
  };
}
