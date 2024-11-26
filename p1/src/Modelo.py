import gi

import locale

gi.require_version('GdkPixbuf', '2.0')
from gi.repository import GdkPixbuf


class Modelo:
    @staticmethod
    def get_cocktail_names(data):
        filtered_data = []
        for i, item in enumerate(data):
            if "strDrink" in item:
                drink_name = item.get("strDrink").replace("&", "&amp;")
                index = i + 1
                filtered_data.append((drink_name, index))
        return filtered_data

    @staticmethod
    def filter_cocktails(cocktails, alcoholic):

        if not cocktails:
            return []

        cocktails_result = cocktails
        if alcoholic == "alcoholic":
            cocktails_result = [
                cocktail for cocktail in cocktails if cocktail.get("strAlcoholic") == "Alcoholic"
            ]
        elif alcoholic == "non_alcoholic":
            cocktails_result = [
                cocktail for cocktail in cocktails if cocktail.get("strAlcoholic") == "Non alcoholic"
            ]
        return cocktails_result

    def process_image(self, image_response):
        image_data = image_response.content
        pixbuf_loader = GdkPixbuf.PixbufLoader.new_with_type('jpeg')
        pixbuf_loader.write(image_data)
        pixbuf_loader.close()
        pixbuf = pixbuf_loader.get_pixbuf()
        return pixbuf

    def process_cocktail(self, data):
        data_dict = dict(data[0])
        ingredients = []
        for i in range(1, 16):
            ingredient_key = f'strIngredient{i}'
            measure_key = f'strMeasure{i}'
            ingredient = data_dict.get(ingredient_key)
            measure = data_dict.get(measure_key)
            if ingredient:
                if measure:
                    ingredients.append(f"{ingredient} - {measure}")
                else:
                    ingredients.append(ingredient)

        cocktail = data_dict.get("strDrink", "")

        if locale.getlocale()[0] == "es_ES":
            instructions = data_dict.get("strInstructionsES", "")
        elif locale.getlocale()[0] == "de_DE":
            instructions = data_dict.get("strInstructionsDE", "")
        elif locale.getlocale()[0] == "fr_FR":
            instructions = data_dict.get("strInstructionsFR", "")
        elif locale.getlocale()[0] == "it_IT":
            instructions = data_dict.get("strInstructionsIT", "")
        else:
            instructions = data_dict.get("strInstructions", "")

        ##Sino hay traducciones, por ejemplo en español, se emplearia el ingles.
        if instructions == None: 
            instructions = data_dict.get("strInstructions", "")

        pixbuf = data[1]
        return cocktail, ingredients, pixbuf, instructions
