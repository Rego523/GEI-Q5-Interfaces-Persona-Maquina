import gi
from gi.repository import GLib

import gettext

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GdkPixbuf

t=gettext.gettext

class Vista:
    def __init__(self):
        # Builder
        self.builder = Gtk.Builder()
        self.builder.add_from_file("cocktails.ui")
        # Ventana
        self.window = self.builder.get_object("ventana")

        self.current_cocktail_info = None
        self.instructions = None
        self.current_ingredients = []

        # Loading window
        self.loading_dialog = None

        self.main_screen = self.builder.get_object("main_screen")

        self.search_cocktail = self.builder.get_object("search_cocktail")
        self.search_ingredients = self.builder.get_object("search_ingredients")
        self.ingredient_search = self.builder.get_object("ingredient_search")

        self.tree = self.builder.get_object("tree")
        self.data = self.builder.get_object("coctel")
        self.toggler_cocktail = self.builder.get_object("toggler_cocktails")
        self.search_grid_go_back = self.builder.get_object("search_grid_go_back")
        self.search_ingredients_go_back = self.builder.get_object("search_ingredients_go_back")

        self.alcoholic_checkbox = self.builder.get_object("alcoholic_checkbox")
        self.non_alcoholic_checkbox = self.builder.get_object("non_alcoholic_checkbox")
        self.stack = self.builder.get_object("stack")
        self.cocktail_grid = self.builder.get_object("cocktail_grid")
        self.dialog_window = self.builder.get_object("dialog_window")
        self.error_label = self.builder.get_object("error_label")

        self.search_text = ""
        self.window.connect("destroy", Gtk.main_quit)

    def run(self):

        ##search_ingredients_go_back
        button_maincocktail = self.builder.get_object("main_cocktail_search") 
        label_button_maincocktail = t("Search cocktails")
        button_maincocktail.set_label(label_button_maincocktail)

        button_mainingredient = self.builder.get_object("main_ingredient_search") 
        label_mainingredient = t("Search ingredients")
        button_mainingredient.set_label(label_mainingredient)


        button_volversearchcocktail = self.builder.get_object("search_grid_go_back") 
        label_volversearchcocktail = t("Return to home screen")
        button_volversearchcocktail.set_label(label_volversearchcocktail)

        search_bar = self.builder.get_object("searchBar") 
        search_bar_text = t("Search for the name of a cocktail...")
        search_bar.set_placeholder_text(search_bar_text)

        button_alcoholic_checkbox = self.builder.get_object("alcoholic_checkbox") 
        label_alcoholic_checkbox = t("Alcoholic drinks")
        button_alcoholic_checkbox.set_label(label_alcoholic_checkbox)

        button_non_alcoholic_checkbox = self.builder.get_object("non_alcoholic_checkbox") 
        label_non_alcoholic_checkbox = t("Non-alcoholic drinks")
        button_non_alcoholic_checkbox.set_label(label_non_alcoholic_checkbox)

        button_main_flter = self.builder.get_object("main_flter") 
        label_main_flter = t("Filter by alcohol")
        button_main_flter.set_label(label_main_flter)

        button_main_discorver = self.builder.get_object("main_discorver") 
        label_main_discorver = t("Discover")
        button_main_discorver.set_label(label_main_discorver)

        button_Random_Button = self.builder.get_object("Random_Button") 
        label_Random_Button = t("Show random cocktail")
        button_Random_Button.set_label(label_Random_Button)


        button_return_button = self.builder.get_object("return_button") 
        label_return_button = t("Return to main search cocktails screen")
        button_return_button.set_label(label_return_button)

        button_Recipe_option = self.builder.get_object("Recipe_option") 
        label_Recipe_option = t("Recipe")
        button_Recipe_option.set_label(label_Recipe_option)

        button_Ingredientes_option = self.builder.get_object("Ingredientes_option") 
        label_Ingredientes_option = t("Ingredients")
        button_Ingredientes_option.set_label(label_Ingredientes_option)


        button_volversearchingredient = self.builder.get_object("search_ingredients_go_back") 
        label_volversearchingredient = t("Return to home screen")
        button_volversearchingredient.set_label(label_volversearchingredient)

        search_bar2 = self.builder.get_object("searchBar2") 
        search_bar_text2 = t("Search for the name of an ingredient...")
        search_bar2.set_placeholder_text(search_bar_text2)

        button_volver = self.builder.get_object("ingredient_go_back") 
        label_volver = t("Return to main search ingredient screen")
        button_volver.set_label(label_volver)

        self.window.show_all()

    def register_handlers(self, handler):
        self.builder.connect_signals(handler)

    def fill_data(self, data):
        self.data.clear()
        for cocktail in data:
            self.data.append(cocktail)

    def set_image_size(self, window_size, pixbuf):
        # Get window size
        window_width, window_height = window_size

        # Define a percentage of window size for image adjustment
        percentage = 0.5

        # Calculate maximum dimensions based on the percentage
        max_width = int(window_width * percentage)
        max_height = int(window_height * percentage)

        # Scale image maintaining aspect ratio
        original_width = pixbuf.get_width()
        original_height = pixbuf.get_height()

        # Calculate scales for fitting the image into the maximum size
        width_scale = max_width / original_width
        height_scale = max_height / original_height

        # Use the smaller scale to maintain aspect ratio
        min_scale = min(width_scale, height_scale)

        # Scale the image to the maximum size while maintaining aspect ratio
        new_width = int(original_width * min_scale)
        new_height = int(original_height * min_scale)
        return pixbuf.scale_simple(new_width, new_height, GdkPixbuf.InterpType.BILINEAR)

    def show_cocktail(self, pixbuf, name, ingredients, instructions):
        # Set cocktail_grid visible
        self.stack.set_visible_child_name("cocktail_grid")

        # Set cocktail name
        self.builder.get_object("cocktail_name").set_text(name)

        # Set cocktail image
        pixbuf = self.set_image_size(self.window.get_size(), pixbuf)
        self.builder.get_object("cocktail_image").set_from_pixbuf(pixbuf)

        # Set ingredients
        self.builder.get_object("cocktail_details").set_text("\n".join(ingredients))

        # Assign class variables
        self.current_cocktail_info = pixbuf
        self.current_ingredients = ingredients
        self.instructions = instructions

    def show_ingredient(self, ingredient_name, pixbuf):
        text_label = t("Cocktails that use: ") + f"{ingredient_name}"

        self.stack.set_visible_child_name("ingredient_search")
        self.builder.get_object("ingredient_label").set_text(text_label)
        self.builder.get_object("ingredient_image").set_from_pixbuf(pixbuf)

    def update_label(self, state):
        if state:
            self.builder.get_object("cocktail_details").set_text(self.instructions)
        else:
            self.builder.get_object("cocktail_details").set_text("\n".join(self.current_ingredients))

    def show_loading(self):
        GLib.idle_add(self.show_loading_dialog)

    def show_loading_dialog(self):
        self.loading_dialog = Gtk.Dialog()
        self.loading_dialog.set_title("Cargando...")
        self.loading_dialog.set_default_size(200, 100)
        self.loading_dialog.set_decorated(False)
        self.loading_dialog.set_modal(True)

        # Center the dialog window in the main window
        self.loading_dialog.set_transient_for(self.window)

        spinner = Gtk.Spinner()
        spinner.start()
        spinner_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        spinner_box.pack_start(spinner, False, False, 0)
        label = Gtk.Label(t("Loading..."))
        spinner_box.pack_start(label, False, False, 0)

        # Add a close button
        close_button = Gtk.Button.new_with_label(t("Close app"))
        close_button.connect("clicked", self.close_loading_dialog)
        close_button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        close_button_box.pack_start(close_button, False, False, 0)

        # Add the spinner and close button to the dialog
        self.loading_dialog.vbox.pack_start(spinner_box, True, True, 0)
        self.loading_dialog.vbox.pack_start(close_button_box, True, True, 0)
        self.loading_dialog.show_all()

        self.loading_dialog.run()

    def close_loading_dialog(self, button):
        self.loading_dialog.response(Gtk.ResponseType.CANCEL)
        Gtk.main_quit()

    def hide_loading(self):
        GLib.idle_add(self.hide_loading_dialog)

    def hide_loading_dialog(self):
        if self.loading_dialog:
            self.loading_dialog.destroy()
            self.loading_dialog = None

    def show_error(self, message):
        GLib.idle_add(self.show_error_dialog, message)

    def show_error_dialog(self, message):
        error_message = Gtk.MessageDialog(
            self.window,
            Gtk.DialogFlags.MODAL,
            Gtk.MessageType.ERROR,
            Gtk.ButtonsType.OK,
            message
        )

        error_message.run()
        error_message.destroy()

    @staticmethod
    def close_window(widget):
        widget.destroy()

    def show_on_stack(self, child_name):
        self.stack.set_visible_child_name(child_name)
