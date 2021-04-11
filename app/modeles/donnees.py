from .. app import db

# Création du modèle de donnée d'un acte
class Acte(db.Model):
    __tablename__ = "Acte"
    acte_id = db.Column(db.Integer, unique=True, nullable=False, primary_key=True, autoincrement=True)
    acte_titre = db.Column(db.Text, unique=True, nullable=False)
    acte_date = db.Column(db.Text, unique=False, nullable=False)
    acte_emetteur = db.Column(db.Text, unique=False, nullable=True)
    acte_type = db.Column(db.Text, unique=False, nullable=False)
    acte_abbatiat = db.Column(db.Text, unique=False, nullable=True)