from flask import render_template, request
from .app import app
from .modeles.donnees import Acte
from .creation_donnees import creation_database
from .constantes import corpus_xml_parsed, xsl_projet_parsed, xsl_acte_parsed, xsl_index_lieux_parsed, xsl_index_noms_parsed
from lxml import etree


actes_par_page = 5


# On crée la base de données en appelant la fonction de création
creation_database(corpus_xml_parsed)

@app.route("/")
def accueil():
    # Route de la page d'accueil, qui affichera le nombre d'actes enregistrés
    actes = Acte.query.order_by(Acte.acte_id.desc()).all()
    return render_template("pages/accueil.html", nom="Cartulaire", actes=actes)

@app.route("/projet")
def projet():
    """Route permettant d'afficher la page de projet :
        La méthode .XSLT() d'etree est appliquée à xsl_projet_parsed et le résultat est 
        stocké dans la variable transformation_xslt_projet ;

        La feuille de transformation est appliquée au document XML (corpus_xml_parsed), 
        le résultat est stocké dans la variable resultat_projet ;

        Enfin, la fonction retourne une template où sont définis la route vers
        le document html où le produit de la fonction sera affiché (pages/projet.html).
    """
    transformation_xslt_projet = etree.XSLT(xsl_projet_parsed)
    resultat_projet = transformation_xslt_projet(corpus_xml_parsed)
    return render_template("pages/projet.html", contenu_projet=resultat_projet)


@app.route("/acte/<int:acte_id>")
def acte(acte_id):
    """Route permettant d'afficher, grâce à la suite d'instruction décrite ci-dessus,
       de retourner une template html contenant les informations sur l'acte que l'on a demandés 
       et organisés grâce à la feuille de transformation xsl.
    """
    acte = Acte.query.get(acte_id)

    transformation_xsl_acte = etree.XSLT(xsl_acte_parsed)
    resultat_acte = transformation_xsl_acte(corpus_xml_parsed, id_acte=str(acte_id))
    return render_template("pages/acte.html", contenu_acte=resultat_acte, id=acte_id, acte=acte, nom="Cartulaire")


@app.route("/index_lieux")
def index_lieux():
    """Route permettant d'afficher la page de l'index de lieux.
       Selon la même technique que les fonctions de routes du projet et de l'acte, 
       cette fonction utilise la feuille de transformation xsl pour afficher la page
       d'index des lieux selon la disposition prévue par celle-ci.
    """
    transformation_xsl_index_lieux = etree.XSLT(xsl_index_lieux_parsed)
    resultats_index_lieux = transformation_xsl_index_lieux(corpus_xml_parsed)
    return render_template("pages/index_lieux.html", contenu_index_lieux=resultats_index_lieux)

@app.route("/index_noms")
def index_noms():
    """Route permettant d'afficher la page de l'index des noms de personnes.
       Elle fonctionne selon le même schéma que les trois précédentes, avec la
       méthode .XSLT() d'etree.
    """
    transformation_xsl_index_noms = etree.XSLT(xsl_index_noms_parsed)
    resultats_index_noms = transformation_xsl_index_noms(corpus_xml_parsed)
    return render_template("pages/index_noms.html", contenu_index_noms=resultats_index_noms)

@app.route("/recherche")
def recherche():

    """Cette route permet d'afficher une page d'où l'on peut faire des recherches selon
       différents critères, et de renvoyer les actes qui répondent à ces critères.

       On définit d'abord des variables qui recevront les entrées des recherches récupérées
       sur la page de recherche.
    """

    motclef = request.args.get("keyword", None)
    acte_type = request.args.get("acte_type", None)
    acte_date = request.args.get("acte_date", None)
    acte_emetteur = request.args.get("acte_emetteur", None)
    acte_abbatiat = request.args.get("acte_abbatiat", None)
    page = request.args.get("page", 1)

    if isinstance(page, str) and page.isdigit():
        page = int(page)
    else:
        page = 1

    # On crée une liste vide de résultat (qui restera vide par défaut
    # si on n'a pas de mot-clé ou de terme de recherche)
    resultats = []
    resultats_dates = []
    resultats_abbatiat = []
    resultats_emetteur = []
    resultats_type = []

    titre = "Recherche"

    # Si on récupère un mot-clef, on teste s'il correspond à une suite de caractères
    # dans le titres des actes et on renvoie les résultats trouvés dans la variable resultats. 
    if motclef:
        resultats = Acte.query.filter(
            Acte.acte_titre.like("%{}%".format(motclef))
        ).paginate(page=page, per_page=actes_par_page)
        titre = "Résultat(s) pour la recherche `" + motclef + "`"


    # On fait de même pour le type, la date, l'émetteur de l'acte et l'abbatiat pendant lequel
    # celui-ci est émis
    elif acte_type:
        resultats_type = Acte.query.filter(
            Acte.acte_type.like("%{}%".format(acte_type))
        ).paginate(page=page, per_page=actes_par_page)
        titre = "Résultat(s) pour la recherche `" + acte_type + "`"

    elif acte_date:
        resultats_dates = Acte.query.filter(
            Acte.acte_date.like("%{}%".format(acte_date))
        ).paginate(page=page, per_page=actes_par_page)
        titre = "Résultat(s) pour la recherche `" + acte_date + "`"

    elif acte_emetteur:
        resultats_emetteur = Acte.query.filter(
            Acte.acte_emetteur.like("%{}%".format(acte_emetteur))
        ).paginate(page=page, per_page=actes_par_page)
        titre = "Résultat(s) pour la recherche `" + acte_emetteur + "`"

    elif acte_abbatiat:
        resultats_abbatiat = Acte.query.filter(
            Acte.acte_abbatiat.like("%{}%".format(acte_abbatiat))
        ).paginate(page=page, per_page=actes_par_page)
        titre = "Résultat(s) pour la recherche `" + acte_abbatiat + "`"

    return render_template(
        "pages/recherche.html",
        resultats=resultats,
        titre=titre,
        keyword=motclef,
        acte_date=acte_date,
        acte_abbatiat=acte_abbatiat,
        acte_emetteur=acte_emetteur,
        acte_type=acte_type,
        resultats_type=resultats_type,
        resultats_dates=resultats_dates,
        resultats_emetteur=resultats_emetteur,
        resultats_abbatiat=resultats_abbatiat
    )


@app.route("/index")
def index():    
    """Cette route renvoie juste l'ensemble des actes enregistrés dans la base, selon les paramètres
    de pagination.
    """

    page = request.args.get("page", 1)
    
    if isinstance(page, str) and page.isdigit():
        page = int(page)
    else:
        page = 1

    actes = Acte.query.order_by(Acte.acte_titre).paginate(page=page, per_page=actes_par_page)

    return render_template("pages/index.html", nom="Cartulaire", actes=actes)


@app.route("/rechercher")
def rechercher():
    """Cette route renvoie vers la page de recherches avancées:

       On initialise des listes vides qui recevront les différents éléments par lesquels on peut
        effectuer une recherche, que l'on va chercher dans la base de données ;
       
       On remplit les listes ;

       Puis on supprime les doublons dans les listes pour n'avoir qu'une occurence de 
       chaque élément.
    """

    liste_types = []
    liste_emetteurs = []
    liste_dates = []
    liste_abbatiats = []

    actes = Acte.query.all()
    
    for acte in actes:
        acte_type = acte.acte_type
        liste_types.append(acte_type)
        acte_emetteur = acte.acte_emetteur
        liste_emetteurs.append(acte_emetteur)
        acte_date = acte.acte_date
        liste_dates.append(acte_date)
        acte_abbatiat = acte.acte_abbatiat
        liste_abbatiats.append(acte_abbatiat)
        
    liste_types = set(liste_types)
    liste_emetteurs = set(liste_emetteurs)
    liste_dates = set(liste_dates)
    liste_abbatiats = set(liste_abbatiats)


    return render_template("pages/rechercher.html",
        liste_types=liste_types,
        liste_emetteurs=liste_emetteurs,
        liste_abbatiats=liste_abbatiats,
        liste_dates=liste_dates
    )