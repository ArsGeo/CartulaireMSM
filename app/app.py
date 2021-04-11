from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os
from lxml import etree

chemin_actuel = os.path.dirname(os.path.abspath(__file__))
templates = os.path.join(chemin_actuel, "templates")
statics = os.path.join(chemin_actuel, "static")

app = Flask(
    "Application",
    template_folder=templates,
    static_folder=statics
)

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
# On configure la base de données
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./msm.sqlite'

# On initie l'extension
db = SQLAlchemy(app)

# On importe la page d'accueil
from .routes import accueil