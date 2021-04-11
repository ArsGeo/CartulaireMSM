# import du module etree de lxml
from lxml import etree
# import de la base de données (db) depuis le fichier app.py :
from .app import db
# import de la classe Acte depuis le fichier donnees.py situé dans le dossier modeles :
from .modeles.donnees import Acte


def creation_database(fichier_xml):


	"""Cette fonction permet de créer une base de données avec les informations issues du fichier xml 
		contenant le corpus des actes (fichier_xml).

		- On définit des listes vides correspondant aux colonnes de la base, et un compteur n,
		correspondant aux id des actes.

		- On boucle ensuite sur chaque élément texte de l'arbre XML :

		- Le compteur n augmente de un à chaque itération, les listes sont complétées, 
		n permet d'indiquer l'id des actes dans le document XML. 

		- Chaque élément à ajouter dans les colonnes est indiqué grâce à un chemin xpath qui inclut, 
		à la place du numéro de l'acte, le compteur n. La méthode .xpath() renvoyant un liste, 
		on ajoute uniquement le premier élément de la liste pour ne pas que la liste conserve 
		les éléments précédents (des autres textes) et éviter des erreurs lors de l'injection.

		- L'ancienne base est détruite grâce à la méthode .drop_all(), puis une nouvelle
		est créée à chaque démarrage de l'application avec .create_all().

		- A chaque itération, le compteur n et l'entrée de chaque liste avec comme index n - 1
		(puisque le premier index d'une liste est 0 et que le compteur n commence à 1) 
		sont ajoutés dans la table Acte grâce à la méthode .add().

		:param xml_file: un document XML parsé avec la méthode .parse() d'etree.
		:type xml_file: str
	"""

	n = 0

	Liste_titres =[]
	Liste_emetteurs =[]
	Liste_dates =[]
	Liste_types =[]
	Liste_abbatiats =[]

	db.drop_all()
	db.create_all()

	for texte in fichier_xml.xpath("//group/text"):

		n += 1

		acte_titre = fichier_xml.xpath("//text[@n="+str(n)+"]//titlePart/text()")
		Liste_titres.append(acte_titre[0])
		acte_date = fichier_xml.xpath("//text[@n="+str(n)+"]//docDate/date/text()")
		Liste_dates.append(acte_date[0])
		acte_emetteur = fichier_xml.xpath("//text[@n="+str(n)+"]//persName[@type='emetteur']/text()")
		Liste_emetteurs.append(acte_emetteur[0])
		acte_type = fichier_xml.xpath("//text[@n="+str(n)+"]//titlePart")
		Liste_types.append(acte_type[0].get('type'))

		# Cas particulier : si l'abbatiat pendant lequel l'acte est émis n'est pas connu
		if fichier_xml.xpath("//text[@n="+str(n)+"]//persName[@type='abbe']/text()"):
			acte_abbatiat = fichier_xml.xpath("//text[@n="+str(n)+"]//persName[@type='abbe']/text()")
			Liste_abbatiats.append(acte_abbatiat[0])
		else:
			acte_abbatiat = "Non connu"
			Liste_abbatiats.append(acte_abbatiat)

		db.session.add(
			Acte(
				acte_id=n,
				acte_titre=Liste_titres[n-1],
				acte_date=Liste_dates[n-1],
				acte_emetteur=Liste_emetteurs[n-1],
				acte_type=Liste_types[n-1],
				acte_abbatiat=Liste_abbatiats[n-1]
		     )
			)
		
	db.session.commit()
