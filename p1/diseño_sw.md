# Diseño software

## Diagrama de clases
	
```mermaid
classDiagram
    class Modelo {
        + get_cocktail_names(data: JSON): Array
        + filter_cocktails(cocktails: Array, alcoholic: String): Array
        + process_image(image_response: Response): GdkPixbuf
        + process_cocktail(data: JSON): Tuple
    }

    class Vista {
        - builder: Gtk.Builder
        - window: Gtk.Window
        - current_cocktail_info: Any
        - instructions: String
        - current_ingredients: Array
        + run()
        + register_handlers(handler: Controlador)
        + fill_data(data: Array)
        + set_image_size(window_size: Tuple, pixbuf: GdkPixbuf): GdkPixbuf
        + show_cocktail(pixbuf: GdkPixbuf, name: String, ingredients: Array, instructions: String)
        + show_ingredient(ingredient_name: String, pixbuf: GdkPixbuf)
        + update_label(state: Boolean)
        + show_loading()
        + show_loading_dialog()
        + close_loading_dialog(widget: Gtk.Button)
        + hide_loading()
        + hide_loading_dialog()
        + show_error(mensaje: String)
        + close_window(widget: Gtk.Widget)
        + show_on_stack(child_name: String)
    }

    class Controlador {
        - api_base_url: String
        - view: Vista
        - model: Modelo
        - first_search: Boolean
        + run()
        + background_cocktail_request(api_base_url: String, endpoint: String): Tuple
        + background_fetch_cocktail(alcoholic_checkbox: Gtk.CheckButton, non_alcoholic_checkbox: Gtk.CheckButton, text: String)
        + background_fetch_ingredients(text: String)
        + background_fetch_cocktail_by_ingredient(text: String)
        + process_cocktail_request(api_base_url: String, endpoint: String): Tuple
        + fetch_cocktails(text: String, alcoholic: String): Array
        + fetch_ingredients(text: String): Array
        + get_cocktail(cocktail_name: String): Tuple
        + fetch_random_cocktail(): Tuple
        + fetch_cocktail_by_ingredient(ingredient: String): Array
        + get_ingredient_image(ingredient_name: String): GdkPixbuf
        + go_to_cocktails_screen(widget: Gtk.Widget)
        + go_to_ingredients_screen(widget: Gtk.Widget)
        + show_cocktail_names(data: Any)
        + on_cocktail_search_activate(entry: Gtk.Entry)
        + on_ingredient_search_activate(entry: Gtk.Entry)
        + on_cocktail_selected(treeview: Gtk.TreeView, path: String, column: String)
        + on_ingredient_selected(treeview: Gtk.TreeView, path: String, column: String)
        + on_switch_state_set(switch: Gtk.Switch, state: Boolean)
        + go_to_main_screen(widget: Gtk.Widget)
        + go_to_ingredient_screen(widget: Gtk.Widget)
        + on_dialog_ok_button_clicked(widget: Gtk.Widget)
        + on_filter_alcoholic_toggled(widget: Gtk.ToggleButton)
        + on_filter_non_alcoholic_toggled(widget: Gtk.ToggleButton)
        + cocktail_selected(cocktail_name: String)
        + on_random_cocktail_clicked(widget: Gtk.Widget)
        + ingredient_selected(ingredient_name: String)
    }

    class CocktailApp {
        +__init__()
        +run()
    }

    Modelo --> Controlador
    Vista --> Controlador
    Controlador --> Modelo
    Controlador --> Vista
    CocktailApp --> Modelo
    CocktailApp --> Vista
    CocktailApp --> Controlador
```

## Diagramas de secuencia
### Caso de uso Buscar Cócteles
	
```mermaid
sequenceDiagram
    participant Vista
    participant Controlador
    participant Modelo
    participant Servidor

    Vista->>+Controlador: go_to_cocktails_screen(widget)
    Controlador->>+Vista: show_on_stack("search_cocktail")
    Vista->>+Controlador: on_cocktail_search_activate(entry)
    Controlador-->>+Vista: if not (text) Error: Search field is empty
    Controlador->>+Controlador: background_fetch_cocktail(alcoholic_checkbox, non_alcoholic_checkbox, text) {Concurrent Call}
    Controlador->>+Controlador: fetch_cocktails(text, alcoholic)
    Controlador->>+Servidor: Petición de datos
    Servidor-->>Controlador: Devolución de datos
    Controlador->>+Modelo: filter_cocktails(cocktails_name, alcoholic)
    Modelo-->>Controlador: Cocktails procesados
    Controlador->>+Vista: show_loading()
    Vista-->>-Controlador: (background task)
    Controlador->>+Vista: hide_loading()
    Controlador-->>-Vista: show_cocktail_names(data)
    Vista-->>-Controlador: Mostrar resultados en la vista

```

### Casos de uso buscar ingrediente y buscar cócteles por ingrediente

```mermaid
sequenceDiagram
    participant Vista
    participant Controlador
    participant Modelo
    participant Servidor

    % Búsqueda de Ingredientes
    Vista->>+Controlador: on_ingredient_search_activate(entry)
    Controlador-->>+Vista: if not (text) Error: Search field is empty 
    Controlador->>+Controlador: background_fetch_ingredients(text) {Concurrent Call}
    Controlador->>+Controlador: fetch_cocktails(text, "alcoholic")
    Controlador->>+Servidor: Petición de datos
    Servidor -->+Controlador: Resolución de datos
    Controlador -->>Vista: if (Connection_error) Error: No internet connection
    Controlador -->>Vista: if (Not Found) Error: No results found for your search
    Controlador->>+Modelo: filter_cocktails(text)
    Modelo-->>-Controlador: Datos procesados
    Controlador-->>+Vista: hide_loading()
    Vista->>+Controlador: fill_data(filtered_data)
    Controlador-->>-Vista: Mostrar resultados en la Vista
    Controlador-->>-Vista: Actualizar Vista

    % Selección de Ingrediente y Búsqueda de Cócteles por Ingrediente
    Vista->>+Controlador: on_ingredient_selected(treeview, path, column)
    Controlador->>+Controlador: background_fetch_cocktail_by_ingredient(ingredient_name) {Concurrent Call}
    Controlador->>+Controlador: fetch_cocktail_by_ingredient(ingredient_name)
    Controlador->>+Servidor: Petición de datos
    Servidor -->+Controlador: Resolución de datos
    Controlador -->>Vista: if (Connection_error) Error: No internet connection
    Controlador -->>Vista: if (Not Found) Error: No results found for your search
    Controlador-->>-Vista: show_ingredient(ingredient_name, pixbuf)
    Controlador->>+Vista: go_to_ingredient_screen(widget)

    % Búsqueda de Cócteles Relacionados al Ingrediente
    Vista->>+Controlador: on_cocktail_search_activate(entry)
    Controlador->>+Controlador: background_fetch_cocktail(alcoholic_checkbox, non_alcoholic_checkbox, text) {Concurrent Call}
    Controlador->>+Controlador: fetch_cocktails(text, alcoholic)
    Controlador->>+Servidor: Petición de datos
    Servidor -->+Controlador: Resolución de datos
    Controlador -->>Vista: if (Connection_error) Error: No internet connection
    Controlador -->>Vista: if (Not Found) Error: No results found for your search
    Controlador-->>+Vista: hide_loading()
    Controlador-->>-Vista: show_cocktail_names(data)
    Vista-->>-Controlador: Mostrar resultados en la Vista

```

### Caso de uso Cocktail Aleatorio

```mermaid
sequenceDiagram
    participant Vista
    participant Controlador
    participant Modelo
    participant Servidor

    Vista->>+Controlador: on_random_cocktail_clicked(widget)
    Controlador->>+Controlador: background_cocktail_request() {LLamada concurrente}
      Controlador->>+Controlador: fetch_cocktails(text, alcoholic)
    Controlador->>+Servidor: Petición de datos
    Servidor -->>Controlador: Resolución de datos
    Controlador -->>Vista: if (Connection_error) Error: No internet connection
    Controlador->>+Modelo: process_image(image)
    Modelo-->>-Controlador: Retornar un cóctel aleatorio
    Controlador->>+Vista: show_cocktail(pixbuf, name, ingredients, instructions)
```

### Caso de uso Filtrado por Alcohol o sin Alcohol
 
```mermaid
sequenceDiagram
    participant Vista
    participant Controlador
    participant Modelo
    participant Servidor

    Vista->>+Controlador: on_filter_alcoholic_toggled(widget)
    Controlador->>+Modelo: fetch_cocktails(text, "alcoholic")
    Modelo->>+Servidor: Se realiza la petición
    Servidor -->>Vista: if (Connection_error) Error: No internet connection
    Servidor -->>Vista: if (alcoholic) Error: No results found with alcoholic filte
    Servidor -->>Vista: if (Not Found) Error: No results found for your searchr
    Servidor -->>Modelo: Devolver datos
    Modelo-->>-Controlador: Retornar resultados de búsqueda de cócteles alcohólicos
    Controlador-->>-Vista: Mostrar resultados en la Vista
    
    Vista->>+Controlador: on_filter_non_alcoholic_toggled(widget)
    Controlador->>+Modelo: fetch_cocktails(text, "non_alcoholic")
    Modelo->>+Servidor: Se realiza la petición
    Servidor -->>Vista: if (Connection_error) Error: No internet connection
    Servidor -->>Vista: if (non-alcoholic) Error: No results found with non-alcoholic filter
    Servidor -->>Vista: if (Not Found) Error: No results found for your searchr
    Modelo-->>-Controlador: Retornar resultados de búsqueda de cócteles no alcohólicos
    Controlador-->>-Vista: Mostrar resultados en la Vista
```

### Caso de uso de Ver cóctel en detalle

```mermaid
sequenceDiagram
    participant Vista
    participant Controlador
    participant Modelo
    participant Servidor

    Vista->>+Controlador: on_cocktail_selected(treeview, path, column)
    Controlador->>+Controlador: get_cocktail(cocktail_name)
    Controlador->>+Servidor: Se realiza la petición
    Servidor-->>Controlador: Devolver datos
    Controlador-->>Vista: if (Connection_error) Error: No internet connection
    Controlador-->>Modelo: Procesar datos de API
    Modelo-->>Controlador: Retornar detalles del cóctel seleccionado
    Controlador-->>-Vista: Mostrar los detalles del cóctel en la Vista

```
