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
          {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["Honda", "Yamaha", "Suzuki"]},
          {"label": "Year", "value":"purchasedYear","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Fuel Type","value":"fuelType", "type": FormFieldType.dropdown, "options": ["Petrol", "Electric"]},
          {"label": "Km Driven","value":"kmDriven", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Owner","value":"owner", "type": FormFieldType.dropdown, "options": ["1st", "2nd", "3rd"]},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "value":"description","type": FormFieldType.description}
        ]
      },
      SubCategory.car: {
        "Car Details": [
          {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["Hyundai", "Suzuki", "Toyota", "Mahindra", "Ford", "Tata", "Other"]},
          {"label": "Year", "value":"purchasedYear","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Fuel Type","value":"fuelType", "type": FormFieldType.dropdown, "options": ["Diesel", "Petrol", "CNG", "Electric","Hybrid"]},
          {"label": "Transmission", "value":"transmission","type": FormFieldType.dropdown, "options": ["Manual", "Automated"]},
          {"label": "Km Driven","value":"kmDriven", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Owner", "value":"owner","type": FormFieldType.dropdown, "options": ["1st", "2nd", "3rd"]},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      },
      SubCategory.cycle: {
        "Cycle Details": [
          {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["Hero", "Hercules", "BSA"]},
          {"label": "Year", "value":"purchasedYear","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.electronics: {
      SubCategory.mobile: {
        "Mobile Details": [
          {"label": "Brand", "value":"brand","type": FormFieldType.dropdown, "options": ["Apple", "Realme", "Nokia", "Samsung", "Google Pixel", "Redmi", "Motorola", "OnePlus", "Oppo", "Other"]},
          {"label": "Year","value":"purchasedYear", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "RAM", "value":"ram","type": FormFieldType.dropdown, "options": ["4GB", "6GB", "8GB","12GB"]},
          {"label": "Storage","value":"storage", "type": FormFieldType.dropdown, "options": ["64GB", "128GB", "256GB","512GB","1TB"]},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      },
      SubCategory.laptop: {
        "Laptop Details": [
          {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["Apple", "Dell", "HP", "Asus", "Lenovo", "Redmi", "Samsung", "Other"]},
          {"label": "Year", "value":"purchasedYear","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "RAM", "value":"ram","type": FormFieldType.dropdown, "options": ["8GB", "16GB", "32GB"]},
          {"label": "Storage","value":"storage", "type": FormFieldType.dropdown, "options": ["256GB", "512GB", "1TB"]},
          {"label": "Processor","value":"processor", "type": FormFieldType.dropdown, "options": ["M1 chip", "M2 chip", "Intel i3", "Intel i5", "Intel i7", "Intel i9", "AMD Ryzen 5"]},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.books: {
      SubCategory.book: {
        "Book Details": [
          {"label": "Title", "value":"title","type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Author", "value":"author","type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Edition", "value":"edition","type": FormFieldType.dropdown, "options": ["1st", "2nd", "3rd","4th"]},
          {"label": "Publisher","value":"publisher", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "value":"description","type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.furniture: {
      SubCategory.furniture: {
        "Furniture Details": [
          {"label": "Type","value":"furnitureType", "type": FormFieldType.dropdown, "options": ["Sofa", "Table", "Chair", "Bed", "Cupboard", "Shelf", "Dining Set", "Other"]},
          {"label": "Material", "value":"material","type": FormFieldType.dropdown, "options": ["Wood", "Metal", "Plastic", "Glass", "Leather", "Fabric", "Other"]},
          {"label": "Condition","value":"condition", "type": FormFieldType.dropdown, "options": ["New", "Good", "Needs Repair"]},
          {"label": "Ad Title","value":"title", "type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "value":"description","type": FormFieldType.description}
        ]
      }
    },
    CategoryGroup.homeappliance: {
      SubCategory.washingMachine: {
        "Appliance Details": [
          {"label": "Brand", "value":"brand","type": FormFieldType.dropdown, "options": ["LG", "Samsung"]},
          {"label": "Capacity", "value":"capacity","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "value":"type","type": FormFieldType.dropdown, "options": ["Top Load", "Front Load"]},
          {"label": "Ad Title", "value":"title","type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      },
      SubCategory.refrigerator: {
        "Appliance Details": [
          {"label": "Brand", "value":"brand","type": FormFieldType.dropdown, "options": ["LG", "Samsung", "Whirlpool"]},
          {"label": "Capacity (L)","value":"capacity", "type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "value":"type","type": FormFieldType.dropdown, "options": ["Single Door", "Double Door"]},
          {"label": "Ad Title", "value":"title","type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information", "value":"description","type": FormFieldType.description}
        ]
      },
      SubCategory.airConditioner: {
        "Appliance Details": [
          {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["LG", "Samsung", "Daikin"]},
          {"label": "Capacity (Ton)", "value":"capacity","type": FormFieldType.text, "keyboard": TextInputType.number},
          {"label": "Type", "value":"type","type": FormFieldType.dropdown, "options": ["Window AC", "Split AC"]},
          {"label": "Ad Title", "value":"title","type": FormFieldType.text, "keyboard": TextInputType.text},
          {"label": "Additional Information","value":"description", "type": FormFieldType.description}
        ]
      }
    },
  };
}