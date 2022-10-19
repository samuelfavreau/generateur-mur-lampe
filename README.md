# Générateur de murs de lampe

**La librairie Hemesh doit être installé pour ce projet**
---> https://github.com/wblut/HE_Mesh

Cette esquisse est un générateur de plans de murs de lampes de chevets de type "lampe fromage" représentant une image donné par l'utilisateur pouvant être lu par une machine à découpe laser.

--

Les plans initiaux sont créés à partir d'une image fournie par l'utilisateur dans le dossier "images" du projet. Cette image est ensuite interprétée en termes de valeurs de gris qui sont ensuite représentés par des trous de différentes tailles. Des trous plus petits pour les valeurs de noirs et des trous plus grands pour les valeurs de blancs. L'utilisateur peut ajuster les différentes propriétés de l'image comme la position et le contraste à l'aide des différentes glissières et boutons présents au-dessus de l'esquisse. La librairie "controlP5" est utilisée pour la gestion de cette interface. L'utilisateur peut également générer des plans pour jusqu'à 5 murs en même temps, tous pouvant être ajusté individuellement. Le bouton "RENDER" permet de visualiser un aperçu 3D de la lampe pouvant être découpé à l'aide des plans. La librairie "Hemesh" est utilisée pour la génération de modèles 3D. La visualisation peut être générée comme une découpe dans un matériau opaque comme du bois ou comme une gravure dans un matériau transparent comme l'acrylique. Un point lumineux représentant la source lumineuse est également présent sur la visualisation.

--

Pour exporter les plans de découpe en SVG, il suffit de cliquer sur le bouton "SAVE" situé sur l'interface d'ajustement. Le fichier sera enregistré dans le dossier "output" du projet.
