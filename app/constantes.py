from lxml import etree

# On parse les différentes feuilles xsl grâce à la méthode .parse() de etree.

corpus_xml_parsed = etree.parse("app/static/xml/actes_msm.xml")

xsl_projet_parsed = etree.parse("app/static/xsl/projet_msm.xsl")

xsl_acte_parsed = etree.parse("app/static/xsl/acte.xsl")

xsl_index_lieux_parsed = etree.parse("app/static/xsl/index_lieux.xsl")

xsl_index_noms_parsed = etree.parse("app/static/xsl/index_noms.xsl")
