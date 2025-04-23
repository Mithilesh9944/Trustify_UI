import 'package:flutter/cupertino.dart';
enum Category{
  car,
  bike,
  property,
  mobile,
  job,
  electronic,
  furniture,
  fashion,
  book,
  sport,
  cycle,
  laptop,
}

enum FormFieldType{
  text,
  dropdown,
  description,
}
class UtilProductForm {

  static Map<Category,Map<String,List<Map<String,dynamic>>>> formCategories = {
    Category.bike:{
      "Bike Details": [
        {"label": "Brand","value":"brand", "type": FormFieldType.dropdown, "options": ["Honda", "Yamaha", "Suzuki"]},
        {"label": "Year","value":"yearOfPurchase", "type": FormFieldType.text, "keyboard": TextInputType.number},
        {"label": "Fuel Type", "value":"fuelType","type": FormFieldType.dropdown, "options": ["Petrol", "Electric"]},
        {"label":"Km Driven","value":"kmDriven", "type":FormFieldType.text,"keyboard":TextInputType.number},
        {"label":"Owner" ,"value":"owner","type": FormFieldType.dropdown,"options":['1st', '2nd', '3rd']},
        {"label":"Ad Title","value":"pTitle","type":FormFieldType.text,"keyboard":TextInputType.text},
        {"label":"Additional Information","value":"pDescription","type":FormFieldType.description}

      ],
      // "Owner Details": [
      //   {"label": "Owner Name", "type": "text"},
      //   {"label": "No. of Owners", "type": "dropdown", "options": ["1st", "2nd", "3rd"]},
      // ],
    },
    Category.car: {
      "Car Details": [
        {
          "label": "Brand",
          "value":"brand",
          "type": FormFieldType.dropdown,
          "options": ["Hyundai", "Suzuki", "Toyota", "Mahindra", "Ford", "Tata", "Other"]
        },
        {
          "label": "Year",
          "value":"yearOfPurchase",
          "type": FormFieldType.text,
          "keyboard": TextInputType.number
        },
        {
          "label": "Fuel Type",
          "value":"fuelType",
          "type": FormFieldType.dropdown,
          "options": ["Diesel", "Petrol", "CNG", "Electric"]
        },
        {
          "label": "Transmission",
          "value":"transmission",
          "type": FormFieldType.dropdown,
          "options": ["Automated", "Manual"]
        },
        {
          "label": "Km Driven",
          "value":"kmDriven",
          "type": FormFieldType.text,
          "keyboard": TextInputType.number
        },
        {
          "label": "Owner",
          "value":"owner",
          "type": FormFieldType.dropdown,
          "options": ["1st", "2nd", "3rd"]
        },
        {
          "label": "Ad title",
          "value":"pTitle",
          "type": FormFieldType.text,
          "keyboard": TextInputType.text
        },
        {
          "label": "Additional Information",
          "value":"pDescription",
          "type": FormFieldType.description
        }
      ]
    },
    Category.cycle: {
      "Cycle Details": [
        {
          "label": "Brand",
           "value":"brand",
          "type": FormFieldType.dropdown,
          "options": ["Hero", "Hercules", "BSA", "Firefox", "Avon", "Montra", "Btwin"]
        },
        {
          "label": "Year",
           "value":"yearOfPurchase",
          "type": FormFieldType.text,
          "keyboard": TextInputType.number
        },
        {
          "label": "Ad title",
          "value":"pTitle",
          "type": FormFieldType.text,
          "keyboard": TextInputType.text
        },
        {
          "label": "Additional Information",
           "value":"pDescription",
          "type": FormFieldType.description
        }
      ]
    },
    Category.laptop: {
      "Laptop Details": [
        {
          "label": "Brand",
           "value":"brand",
          "type": FormFieldType.dropdown,
          "options": ["Apple", "Dell", "HP", "Asus", "Lenovo", "Redmi", "Samsung", "Other"]
        },
        {
          "label": "Year",
           "value":"yearOfPurchase",
          "type": FormFieldType.text,
          "keyboard": TextInputType.number
        },
        {
          "label": "RAM",
            "value":"ram",
          "type": FormFieldType.dropdown,
          "options": ["8GB", "16GB", "32GB", "64GB"]
        },
        {
          "label": "Storage",
           "value":"storage",
          "type": FormFieldType.dropdown,
          "options": ["256GB", "512GB", "1TB"]
        },
        {
          "label": "Processor",
           "value":"processor",
          "type": FormFieldType.dropdown,
          "options": ["M1 chip", "M2 chip", "Intel i3", "Intel i5", "Intel i7", "Intel i9", "AMD Ryzen 5"]
        },
        {
          "label": "Ad title",
           "value":"pTitle",
          "type": FormFieldType.text,
          "keyboard": TextInputType.text
        },
        {
          "label": "Additional Information",
           "value":"pDescription",
          "type": FormFieldType.description
        }
      ]
    },
    Category.mobile: {
      "Mobile Details": [
        {
          "label": "Brand",
          "value":"brand",
          "type": FormFieldType.dropdown,
          "options": ["Apple", "Realme", "Nokia", "Samsung", "Google Pixel", "Redmi", "Motorola", "OnePlus", "Oppo", "Other"]
        },
        {
          "label": "Year",
           "value":"yearOfPurchase",
          "type": FormFieldType.text,
          "keyboard": TextInputType.number
        },
        {
          "label": "RAM",
          "value":"ram",
          "type": FormFieldType.dropdown,
          "options": ["2GB", "3GB", "4GB", "6GB", "8GB", "12GB"]
        },
        {
          "label": "Storage",
           "value":"storage",
          "type": FormFieldType.dropdown,
          "options": ["32GB", "64GB", "128GB", "256GB", "512GB", "1TB"]
        },
        {
          "label": "Ad title",
           "value":"pTitile",
          "type": FormFieldType.text,
          "keyboard": TextInputType.text
        },
        {
          "label": "Additional Information",
           "value":"pDescription",
          "type": FormFieldType.description
        }
      ]
    },
    Category.furniture: {
      "Furniture Details": [
        {
          "label": "Furniture Type",
           "value":"furnituerType",
          "type": FormFieldType.dropdown,
          "options": ["Sofa", "Table", "Chair", "Bed", "Cupboard", "Shelf", "Dining Set", "Other"]
        },
        {
          "label": "Material",
           "value":"material",
          "type": FormFieldType.dropdown,
          "options": ["Wood", "Metal", "Plastic", "Glass", "Leather", "Fabric", "Other"]
        },
        {
          "label": "Condition",
           "value":"condition",
          "type": FormFieldType.dropdown,
          "options": ["New", "Like New", "Good", "Used", "Needs Repair"]
        },
        {
          "label": "Ad title",
           "value":"pTitle",
          "type": FormFieldType.text,
          "keyboard": TextInputType.text
        },
        {
          "label": "Additional Information",
           "value":"pDescription",
          "type": FormFieldType.description
        },
      ]
    },
  };
}