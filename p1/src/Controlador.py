import gi
import requests
import urllib.request

import time
import threading

import gettext

gi.require_version('GdkPixbuf', '2.0')
from gi.repository import GdkPixbuf

SLEEP_TIME = 0

t=gettext.gettext

class Controlador:
    def __init__(self, view, model):
        # API
        self.api_base_url = "https://www.thecocktaildb.com/api/json/v1/1/"

        # Builder
        self.view = view
        self.model = model
        self.view.register_handlers(self)
        self.first_search = True

    def run(self):
        self.view.run()

    # Funciones de Concurrencia:

    def background_cocktail_request(self, api_base_url, endpoint):
        def worker():
            self.view.show_loading()
            time.sleep(SLEEP_TIME)

            cocktail_info = self.process_cocktail_request(api_base_url, endpoint)
            self.view.hide_loading()
            if cocktail_info == "connection_error":
                self.view.show_error(t("ERROR: No internet connection"))
            elif cocktail_info:
                name, ingredients, pixbuf, instructions = self.model.process_cocktail(cocktail_info)
                self.view.show_cocktail(pixbuf, name, ingredients, instructions)
            else:
                self.view.stack.set_visible_child_name("cocktail_not_found")

        thread = threading.Thread(target=worker)
        thread.start()

    def background_fetch_cocktail(self, alcoholic_checkbox, non_alcoholic_checkbox, text):
        def worker():
            self.view.show_loading()
            time.sleep(SLEEP_TIME)
            if alcoholic_checkbox.get_active():
                data = self.fetch_cocktails(text, "alcoholic")
            elif non_alcoholic_checkbox.get_active():
                data = self.fetch_cocktails(text, "non_alcoholic")
            else:
                data = self.fetch_cocktails(text)
            self.view.hide_loading()
            self.show_cocktail_names(data)

        thread = threading.Thread(target=worker)
        thread.start()

    def background_fetch_ingredients(self, text):
        def worker():
            self.view.show_loading()
            time.sleep(SLEEP_TIME)

            data = self.fetch_ingredients(text)
            self.view.hide_loading()

            if data == "connection_error":
                self.view.show_error(t("ERROR: No internet connection"))
            elif not data:
                self.view.show_error(t("ERROR: No results found for your search"))
            else:
                filtered_data = []
                for i, item in enumerate(data):
                    if "strIngredient" in item:
                        ingredient_name = item.get("strIngredient")
                        index = i + 1
                        filtered_data.append((ingredient_name, index))

                self.view.fill_data(filtered_data)

        thread = threading.Thread(target=worker)
        thread.start()

    def background_fetch_cocktail_by_ingredient(self, ingredient_name):
        def worker():
            self.view.show_loading()
            time.sleep(SLEEP_TIME)
            cocktails_info = self.fetch_cocktail_by_ingredient(ingredient_name)
            pixbuf = self.get_ingredient_image(ingredient_name)

            self.view.hide_loading()
            self.show_cocktail_names(cocktails_info)

            if cocktails_info == "connection_error":
                self.view.show_error(t("ERROR: No internet connection"))
            elif cocktails_info:
                self.view.show_ingredient(ingredient_name, pixbuf)
            else:
                print("ERROR: No results found for your search")

        thread = threading.Thread(target=worker)
        thread.start()

    # I/O functions

    def process_cocktail_request(self, api_base_url, endpoint):
        try:
            response = requests.get(api_base_url + endpoint)
            data = response.json()
            drinks = data.get("drinks", [])

            if drinks and isinstance(drinks[0], dict):
                cocktail = drinks[0]
                image_url = cocktail.get("strDrinkThumb", "")
                image_response = requests.get(image_url)
                pixbuf = self.model.process_image(image_response)
                return cocktail, pixbuf
        except requests.exceptions.RequestException:
            return "connection_error"

    def get_cocktail(self, cocktail_name):
        endpoint = "search.php?s=" + cocktail_name
        return self.background_cocktail_request(self.api_base_url, endpoint)

    def fetch_random_cocktail(self):
        endpoint = "random.php"
        return self.background_cocktail_request(self.api_base_url, endpoint)

    def fetch_cocktails(self, text, alcoholic=None):
        if not text:
            return []
        try:
            response = requests.get(self.api_base_url + "search.php?s=" + text)
            data = response.json()
            cocktails_name = data.get("drinks", [])

            return self.model.filter_cocktails(cocktails_name, alcoholic)

        except requests.exceptions.RequestException:
            return "connection_error"

    def fetch_ingredients(self, text):
        try:
            response = requests.get(self.api_base_url + "search.php?i=" + text)
            data = response.json()
            return data.get("ingredients", [])
        except requests.exceptions.RequestException:
            return "connection_error"

    def fetch_cocktail_by_ingredient(self, ingredient):
        try:
            response = requests.get(self.api_base_url + "filter.php?i=" + ingredient)
            data = response.json()
            return data.get("drinks", [])
        except requests.exceptions.RequestException:
            return "connection_error"

    def get_ingredient_image(self, ingredient_name):
        try:
            image_url = f"http://www.thecocktaildb.com/images/ingredients/{ingredient_name}-Medium.png"
            response = urllib.request.urlopen(image_url)
            loader = GdkPixbuf.PixbufLoader()
            loader.write(response.read())
            loader.close()
            pixbuf = loader.get_pixbuf()
            return pixbuf

        except requests.exceptions.RequestException:
            return "connection_error"

    # ----------------------------------------------

    def go_to_cocktails_screen(self, widget):
        self.view.show_on_stack("search_cocktail")
        self.view.data.clear()
        self.first_search = True

    def go_to_ingredients_screen(self, widget):
        self.view.show_on_stack("search_ingredients")
        self.view.data.clear()

    def cocktail_selected(self, cocktail_name):
        self.get_cocktail(cocktail_name)

    def on_random_cocktail_clicked(self, widget):
        self.fetch_random_cocktail()

    def show_cocktail_names(self, data):
        if data == "connection_error":
            self.view.show_error(t("ERROR: No internet connection"))
        elif not data:
            if self.view.alcoholic_checkbox.get_active():
                self.view.show_error(t("ERROR: No results found with alcoholic filter"))
            elif self.view.non_alcoholic_checkbox.get_active():
                self.view.show_error(t("ERROR: No results found with non-alcoholic filter"))
            else:
                self.view.show_error(t("ERROR: No results found for your search"))
        else:
            filtered_data = self.model.get_cocktail_names(data)
            self.view.fill_data(filtered_data)

    def on_cocktail_search_activate(self, entry):
        self.first_search = False
        text = entry.get_text()
        if not text:
            self.view.show_error(t("ERROR: Search field is empty, enter a text to search"))
        else:
            alcoholic_checkbox = self.view.builder.get_object("alcoholic_checkbox")
            non_alcoholic_checkbox = self.view.builder.get_object("non_alcoholic_checkbox")
            self.view.search_text = text
            self.background_fetch_cocktail(alcoholic_checkbox, non_alcoholic_checkbox, text)

    def on_ingredient_search_activate(self, entry):
        text = entry.get_text()
        if not text:
            self.view.show_error(t("ERROR: Search field is empty, enter a text to search"))
        else:
            self.background_fetch_ingredients(text)

    def on_cocktail_selected(self, treeview, path, column):
        # Obtener el nombre del cóctel seleccionado
        model = treeview.get_model()
        iter = model.get_iter(path)
        cocktail_name = model.get_value(iter, 0)
        # Llamar al controlador para manejar la selección del cóctel
        self.cocktail_selected(cocktail_name)

    def on_ingredient_selected(self, treeview, path, column):
        model = treeview.get_model()
        iter = model.get_iter(path)
        ingredient_name = model.get_value(iter, 0)
        self.ingredient_selected(ingredient_name)

    def on_switch_state_set(self, switch, state):
        self.view.update_label(state)

    def go_to_main_screen(self, widget):
        self.view.show_on_stack("main_screen")

    def go_to_ingredient_screen(self, widget):
        self.view.show_on_stack("search_ingredients")
        self.view.data.clear()

    def on_dialog_ok_button_clicked(self, widget):
        window = widget.get_toplevel()
        self.view.close_window(window)

    def on_filter_alcoholic_toggled(self, widget):
        if widget.get_active():
            self.view.alcoholic_checkbox.set_active(True)
            self.view.non_alcoholic_checkbox.set_active(False)
            if not self.first_search:
                text = self.view.search_text
                data = self.fetch_cocktails(text, "alcoholic")
                self.show_cocktail_names(data)
        elif not self.first_search:
            text = self.view.search_text
            data = self.fetch_cocktails(text)
            self.show_cocktail_names(data)

    def on_filter_non_alcoholic_toggled(self, widget):
        if widget.get_active():
            self.view.non_alcoholic_checkbox.set_active(True)
            self.view.alcoholic_checkbox.set_active(False)
            if not self.first_search:
                text = self.view.search_text
                data = self.fetch_cocktails(text, "non_alcoholic")
                self.show_cocktail_names(data)
        elif not self.first_search:
            text = self.view.search_text
            data = self.fetch_cocktails(text)
            self.show_cocktail_names(data)

    def ingredient_selected(self, ingredient_name):
        self.view.data.clear()
        self.background_fetch_cocktail_by_ingredient(ingredient_name)
