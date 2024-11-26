from Modelo import Modelo
from Vista import Vista
from Controlador import Controlador

import gi

import locale
import gettext

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


locale.setlocale(locale.LC_ALL, '')
locale_dir = "locale"
locale.bindtextdomain("ipm_grupo27", locale_dir)

gettext.bindtextdomain("ipm_grupo27", locale_dir)
gettext.textdomain("ipm_grupo27")

##Esto seria en Italiano:
##xgettext --language=Python --keyword=t --output=it.po Vista.py Controlador.py 
##nano it.po  [Aqui tienes que cambiar CHARSET por UTF-8]
##msgfmt it.po -o locale/it/LC_MESSAGES/ipm_grupo27.mo
##LC_ALL=it_IT.UTF-8 LANGUAGE=it_IT.UTF-8 python3 CocktailApp.py 

##Español:
##LC_ALL=es_ES.UTF-8 LANGUAGE=es_ES.UTF-8 python3 CocktailApp.py 

##Ingles:
##LC_ALL=en_GB.UTF-8 LANGUAGE=en_GB.UTF-8 python3 CocktailApp.py

##Aleman:
##LC_ALL=de_DE.UTF-8 LANGUAGE=de_DE.UTF-8 python3 CocktailApp.py



class CocktailApp:
    def __init__(self):
        self.model = Modelo()
        self.view = Vista()
        self.controller = Controlador(self.view, self.model)

    def run(self):
        self.controller.run()
        Gtk.main()


app = CocktailApp()
app.run()
