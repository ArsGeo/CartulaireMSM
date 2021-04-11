<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- Déclaration d'un paramètre correspondant à l'id de l'acte que l'on veut afficher -->
    <xsl:param name="id_acte"/>

    <xsl:template match="/">

        <!-- Ajout de mise en forme CSS -->
        <xsl:element name="style">
            <xsl:attribute name="type">
                <xsl:text>text/css</xsl:text>
            </xsl:attribute>
            <xsl:text>h3 {
                text-align: center;
                margin-top: 65px;
                margin-bottom: 65px;
            }
            p, li {
                text-align: justify;
                text-justify: auto;
                margin-bottom: 50px;
                font-size: 18px;
            }
            .lat {
                font-style: italic;
            }
            img {
                width: 750px;
                display: block;
                margin-left: auto;
                margin-right: auto;
                text-align
            }
            .legende {
            text-align: center;
            
            }
            </xsl:text>
        </xsl:element>

        <!-- Template pour l'affichage de l'analyse de l'acte -->
        <xsl:element name="h3">Analyse</xsl:element>
        <xsl:element name="p">
            <xsl:apply-templates select="//text[@n = $id_acte]//div[@type = 'Analyse']"/>
        </xsl:element>

        <!-- Template pour l'affichage de la tradition de l'acte -->
        <xsl:element name="h3">Tradition</xsl:element>
        <xsl:element name="p">
            <xsl:apply-templates
                select="//text[@n = $id_acte]//div[@type = 'Tableau_de_la_tradition']"/>
        </xsl:element>

        <!-- Affichage de la dissertation critique -->
        <xsl:element name="h3">Dissertation critique</xsl:element>
        <xsl:element name="div">
            <xsl:apply-templates
                select="//text/group/text[@n = $id_acte]//div[@type = 'Dissertation_critique']"/>
        </xsl:element>

        <!-- Affichage du texte -->
        <xsl:element name="h3">Texte</xsl:element>
        <xsl:element name="p">
            <xsl:apply-templates select="//text/group/text[@n = $id_acte]//body"/>
        </xsl:element>

        <xsl:element name="p"/>

        <!-- Création d'une balise div qui recevra les notes du texte -->
        <xsl:element name="div">
            <xsl:apply-templates select="//text/group/text[@n = $id_acte]//note/p"/>
        </xsl:element>

        <xsl:element name="p"/>

        <!-- Création d'une balise div qui recevra la ou les fac-similés de l'acte -->
        <xsl:element name="div">
            <xsl:for-each select="//facsimile[@n = $id_acte]/graphic">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:apply-templates select="//facsimile[@n = $id_acte]/@source"/>
        </xsl:element>

    </xsl:template>



    <xsl:template match="div[@type = 'Dissertation_critique']">
        <!-- Respect des paragraphes de la dissertation critique -->
        <xsl:for-each select="./p">
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="note">
        <!-- A la place de chaque note rencontrée dans le texte, on ajoute un numéro qui sert d'id à la note, qui s'incrémente automatiquement
        à chaque note, et qui correspondra au numéro de la note affichée dans la div sous le texte -->
        <xsl:element name="sup">
            <xsl:element name="a">
                <!-- @href pour lier l'appel à l'id de la note -->
                <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                    <xsl:number count="//text/group/text[@n = $id_acte]//note" level="any" format="1"/>
                </xsl:attribute>
                <!-- numéro de la note -->
                <xsl:number count="//text/group/text[@n = $id_acte]//note" level="any" format="1"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="note/p">
        <xsl:element name="p">
            <!-- Un @id cible le @href de l'appel de note dans le texte -->
            <xsl:attribute name="id">
                <xsl:number count="//text/group/text[@n = $id_acte]//note/p" level="any" format="1"/>
            </xsl:attribute>
            <xsl:text>(</xsl:text>
            <!-- numéro de la note -->
            <xsl:number count="//text/group/text[@n = $id_acte]//note/p" level="any" format="1"/>
            <xsl:text>) </xsl:text>
            <!-- texte de la note -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="body">
        <!-- Affichage du texte de l'acte dans un paragraphe et dans une balise div -->
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:text>lat</xsl:text>
            </xsl:attribute>
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="div[@type = 'Tableau_de_la_tradition']">
        <!-- Affichage du tableau de tradition avec les copies manuscrites et les éditions -->
        <xsl:element name="div">
            
            <!-- Affichage de chaque copie manuscrite de l'acte dans une liste au format html -->
            <xsl:element name="h4">Copies manuscrites</xsl:element>
            <xsl:element name="ul">
                <xsl:for-each
                    select="//text[@n = $id_acte]//listWit[@n = 'Copies_manuscrites']/witness">
                    <xsl:element name="li">
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>

            <xsl:element name="p"/>

            <!-- Même chose pour les éditions -->
            <xsl:element name="h4">Éditions</xsl:element>
            <xsl:element name="ul">
                <xsl:for-each select="//text[@n = $id_acte]//listWit[@n = 'Éditions']/witness">
                    <xsl:element name="li">
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="div[@type = 'Analyse']">
        <!-- Affichage de l'analyse de l'acte -->
        <xsl:element name="div">
                <xsl:element name="p">
                    <xsl:apply-templates/>
                </xsl:element>            
        </xsl:element>
    </xsl:template>

    <xsl:template match="g">
        <!-- Pourc chaque balise notifiant une signature par une croix, on ajoute un caractère de croix -->
        <xsl:text>†</xsl:text>
    </xsl:template>

    <xsl:template match="graphic">
        <!-- Création d'une balise image en html avec un @url qui récupère l'emplacement de l'image -->
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="./@url"/>
            </xsl:attribute>
        </xsl:element>
        <!-- Paragraphe en plus pour accueillir la légende -->
        <xsl:element name="p">
            <xsl:attribute name="class">
                <xsl:text>legende</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hi[@rend = 'italic']">
        <!-- Misen forme des mots en italique -->
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="hi[@rend = 'sup']">
        <!-- Mise en forme des lettres en exposant -->
        <xsl:element name="sup">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
