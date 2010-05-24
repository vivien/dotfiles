#/bin/bash

####################################
## CE SCRIPT N'EST PLUS MAINTENU. ##
## IL A ETE REECRIT EN RUBY.      ##
####################################

##########################################################
# Ce script genere un squelette LaTeX,
# un Makefile et eventuellement des fichiers de conf,
# en fonction des options.
#
# Par Vivien DIDELOT aka v0n
#
# Parametres : [OPTIONS...] [DESTINATION]
# OPTIONS :
# -m, --math
#	importe les paquets mathematiques
#	desactive par defaut
# -l, --listings
#	insertion de codes sources (paquet listings),
#	et cree un fichier de config avec la coloration syntaxique
#	pour le langage C et console
#	desactive par defaut
# -f, --fancyhdr
#	en-tete et pied de page personnalises (paquet fancyhdr)
#	desactive par defaut
# -p, --pdf
#	configuration specifique au pdf
#	desactive par defaut
# -i, --images
#	paquets necessaire a l'insertion d'images
#	desactive par defaut
# -n FILENAME, --name=FILENAME
#	donne le nom FILENAME.pdf au fichier final
# -a AUTHOR, --author=AUTHOR
#	auteur du document
#	utilisateur de la machine par defaut
# -t TITLE, --title=TITLE
#	titre du document
# -d DATE, --date=DATE
#	date du document
# -c CLASS, --class=CLASS
#	classe du document
#	"article" par defaut
# -P PACKAGE, --package=PACKAGE
#	importe le paquet PACKAGE
# -A, --all
#	equivalent a -c report -mhlfpi
# --help
#	affiche l'aide
# --version
#	affiche la version du script
##########################################################

# stopper automatiquement sur une erreur
set -e

# nom du script
SCRIPT="$(basename $0)"
VERSION=1.6
ERR=65

# sauver le backslash pour le code LaTeX
BS="\\"

# parametres par defaut
OUTPUTDIR="$(pwd)"
MATH=false
LISTINGS=false
FANCYHDR=false
PDF=false
GRAPHICS=false
LISTINGS_PATH="src/"
LISTINGS_CONF="lst_conf"
GRAPHICS_PATH="fig/"
GRAPHICS_SUM="fig.tex.txt"
TEXFILENAME="main"
FILENAME=$TEXFILENAME
MAKEFILE="Makefile"
FULLNAME="$(cat /etc/passwd | grep $USER | cut -d: -f5 | cut -d, -f1)"
AUTHOR="${FULLNAME:-$USER}"
TITLE="Document ${BS}LaTeX"
DATE="${BS}today"
CLASS="article"
FLYLEAF="flyleaf"
MORE_PACKAGES=()

# fonction d'affichage des parametres
function PrintValues()
{
	printf "%-10s%-26s%s\n" "option :" "attribut :" "valeur :"
	echo "--------------------------------------------"
	printf "%-10s%-26s%s" "" "destination" "$OUTPUTDIR"
	if [ "$OUTPUTDIR" = "$(pwd)" ]
		then echo " (dossier courant)"
		else echo
	fi
	printf "%-10s%-26s" "-m" "math"
	if $MATH
		then echo "oui"
		else echo "non"
	fi
	printf "%-10s%-26s" "-l" "listings"
	if $LISTINGS
		then echo "oui, dossier $OUTPUTDIR/$LISTINGS_PATH"
		else echo "non"
	fi
	printf "%-10s%-26s" "-f" "fancyhdr"
	if $FANCYHDR
		then echo "oui"
		else echo "non"
	fi
	printf "%-10s%-26s" "-p" "config pdf"
	if $PDF
		then echo "oui"
		else echo "non"
	fi
	printf "%-10s%-26s" "-i" "images"
	if $GRAPHICS
		then echo "oui, dossier $OUTPUTDIR/$GRAPHICS_PATH"
		else echo "non"
	fi
	printf "%-10s%-26s%s\n" "-n" "nom du fichier" "$FILENAME"
	printf "%-10s%-26s%s\n" "-a" "auteur" "$AUTHOR"
	printf "%-10s%-26s%s\n" "-t" "titre" "$TITLE"
	printf "%-10s%-26s%s" "-d" "date" "$DATE"
	if [ "$DATE" = "${BS}today" ]
		then echo " ($(date "+%d %B %Y"))"
		else echo
	fi
	printf "%-10s%-26s%s\n" "-c" "classe" "$CLASS"
	printf "%-10s%-26s" "-P" "paquets supplementaires"
	if [ ${#MORE_PACKAGES[@]} -eq 0 ]
		then echo "aucun"
		else echo "oui: ${MORE_PACKAGES[@]}"
	fi
}

# fonction d'affichage de l'utilisation du script
function PrintUsage()
{
	echo "USAGE:"
	echo "$SCRIPT [-m|-l|-f|-p|-i|-n FILENAME|-a AUTHOR|-t TITLE|-d DATE|-c CLASS|-P PACKAGE|-A] [DESTINATION]"
	echo "-A est equivalent a -mlfpi -c \"report\""
	echo "Aide : $SCRIPT --help"
}

# interpretation des parametres
while getopts "mlfpin:a:t:d:c:P:-:AB" OPT 
do
	# gestion des options longues avec ou sans argument
	if [ $OPT = "-" ] ; then
		LONGOPT="${OPTARG%%=*}"
		OPTARG="${OPTARG#*=}"
		case $LONGOPT in
			math) OPT="m" ;;
			listings) OPT="l" ;;
			fancyhdr) OPT="f" ;;
			pdf) OPT="p" ;;
			images) OPT="i" ;;
			name) OPT="n" ;;
			author) OPT="a" ;;
			title) OPT="t" ;;
			date) OPT="d" ;;
			class) OPT="c" ;;
			package) OPT="P" ;;
			all) OPT="A" ;;
			help) PrintUsage ; echo -e "\nVALEURS PAR DEFAUT:" ; PrintValues ; exit 0 ;;
			version) echo "$SCRIPT: version $VERSION" && exit 0 ;;
			*) echo "$SCRIPT: option longue non permise -- $LONGOPT" >&2 ; PrintUsage ; exit $ERR ;;
		esac
	fi
	case $OPT in
		m) MATH=true ;;
		l) LISTINGS=true ;;
		f) FANCYHDR=true ;;
		p) PDF=true ;;
		i) GRAPHICS=true ;;
		n) FILENAME="$OPTARG" ;;
		a) AUTHOR="$OPTARG" ;;
		t) TITLE="$OPTARG" ;;
		d) DATE="$OPTARG" ;;
		c) CLASS="$OPTARG" ;;
		P) MORE_PACKAGES=(${MORE_PACKAGES[@]} $OPTARG) ;;
		A) CLASS="report" ; MATH=true ; LISTINGS=true ; FANCYHDR=true ; PDF=true ; GRAPHICS=true ;;
		*) PrintUsage ; exit $ERR ;;
	esac
done

shift $(($OPTIND - 1))

if [ $# -gt 1 ] ; then
	echo "$SCRIPT: Mauvaise syntaxe." >&2
	PrintUsage
	exit $ERR
elif [ $# -eq 1 -a "$1" != "." ] ; then
	OUTPUTDIR="${1%/}"
	[ "${OUTPUTDIR:0:1}" != "/" ] && OUTPUTDIR="$(pwd)/$OUTPUTDIR"
fi
# else $# -eq 0

# demander confirmation
PrintValues
echo
read -p "Voulez-vous continuer [Y/n/h] ? " QUESTION
case $QUESTION in
	Y|y|'') echo ;;
	n) echo "$SCRIPT: Abandon."; exit 0 ;;
	h) PrintUsage ; exit 0 ;;
	*) echo "$SCRIPT: Reponse invalide." >&2 ; exit $ERR ;;
esac

# verifier la destination
if [ ! -d $OUTPUTDIR ] ; then
	mkdir -vp $OUTPUTDIR
elif [ -e $OUTPUTDIR/$TEXFILENAME.tex ] ; then
	echo "$OUTPUTDIR: il existe deja un fichier \`$TEXFILENAME.tex'." >&2
	exit $ERR
elif [ -e $OUTPUTDIR/$MAKEFILE ] ; then
	echo "$OUTPUTDIR: il existe deja un \`$MAKEFILE'." >&2
	exit $ERR
fi

$LISTINGS && mkdir -v $OUTPUTDIR/$LISTINGS_PATH
$GRAPHICS && mkdir -v $OUTPUTDIR/$GRAPHICS_PATH

# creation du makefile
FILE="$OUTPUTDIR/$MAKEFILE"
touch $FILE
echo "$SCRIPT: creation du $MAKEFILE"

cat << EOD > $FILE
# $MAKEFILE genere le $(date)
# par $AUTHOR a l'aide du script $SCRIPT

FINAL_FILENAME=$FILENAME
FILENAME=main
VIEWER=gnome-open
RUBBER=\$(shell which rubber)

all: \$(FILENAME).tex
ifeq (\$(RUBBER),)
	pdflatex \$(FILENAME).tex
	pdflatex \$(FILENAME).tex
	@echo -e "\nIl est conseillé d'installer le paquet rubber."
else
	\$(RUBBER) -d \$(FILENAME).tex
endif
	mv \$(FILENAME).pdf \$(FINAL_FILENAME).pdf

view: all
	\$(VIEWER) \$(FINAL_FILENAME).pdf

clean:
	rm -f *.aux *.log *.out *.toc *.lol *.lof *.nav *.snm
	rm -f \$(FINAL_FILENAME).tar

archive: all clean
	tar -cf \$(FINAL_FILENAME).tar *
EOD

# creation du fichier de config de listings si besoin
if $LISTINGS ; then
	FILE="$OUTPUTDIR/$LISTINGS_CONF.tex"
	touch $FILE
	echo "$SCRIPT: creation du fichier \`$LISTINGS_CONF.tex'"

cat << EOD > $FILE
% fichier de config du paquet listings genere le $(date)
% par $AUTHOR a l'aide du script $SCRIPT
%
% /!\ ne pas utiliser de caracteres accentues dans les sources (ne gere pas l'utf-8)
% pour remplacer les lettres accentues : sed -i -e "y/ÉÈÊÇÀÔéèçàôîêûùï/EEECAOeecaoieuui/" fichier

% definition de couleurs pour les listings :
${BS}definecolor{listingbg}{rgb}{1,0.952,0.826}
${BS}definecolor{string}{rgb}{0.141,0.360,1}
${BS}definecolor{comment}{rgb}{0.556,0.548,0.859}
${BS}definecolor{keyword}{HTML}{733A1F}
${BS}definecolor{identifier}{HTML}{9F6431}

% configuration des listings (C par defaut) :
${BS}lstset{%
	language=C,
	tabsize=3,
	xleftmargin=0.75cm,
	numbers=left,
	numberstyle=${BS}tiny,
	extendedchars=true,
	%frame=single,
	%frameround=tttt,
	framexleftmargin=8mm,
	float,
	showstringspaces=true,
	showspaces=false,
	showtabs=false,
	breaklines=true,
	backgroundcolor=${BS}color{listingbg},
	basicstyle=${BS}color{black} ${BS}small,
	keywordstyle=${BS}color{keyword} ${BS}bfseries,
	ndkeywordstyle=${BS}color{keyword} ${BS}bfseries,
	commentstyle=${BS}color{comment} ${BS}itshape,
	identifierstyle=${BS}color{identifier},
	stringstyle=${BS}color{string}
}

% configuration des listings console :
${BS}lstnewenvironment{console}
{${BS}lstset{%
	language={},
	numbers=none,
	extendedchars=true,
	framexleftmargin=5mm,
	%float,
	showstringspaces=false,
	showspaces=false,
	showtabs=false,
	breaklines=false,
	backgroundcolor=${BS}color{darkgray},
	basicstyle=${BS}color{white} ${BS}scriptsize ${BS}ttfamily,
	keywordstyle=${BS}color{white},
	ndkeywordstyle=${BS}color{white},
	commentstyle=${BS}color{white},
	identifierstyle=${BS}color{white},
	stringstyle=${BS}color{white}
}}
{}

${BS}renewcommand{${BS}lstlistlistingname}{Table des codes sources} % renommer la liste des listings

% commande pour afficher le lien vers un listing :
${BS}newcommand{${BS}lstref}[1]{{${BS}footnotesize Listing~${BS}ref{#1}, p.~${BS}pageref{#1}}}

% commande pour simplifier l'emplacement d'un listing :
${BS}newcommand{${BS}lstsrc}[1]{$LISTINGS_PATH#1}

% un listing depuis un fichier s'importe comme ceci : ${BS}lstinputlisting[caption={Legende}, label=lst:label]{emplacement}
EOD
fi

# creation de la page de garde personnalisee si besoin
if [ "$CLASS" = "report" ] ; then
	FILE="$OUTPUTDIR/$FLYLEAF.tex"
	touch $FILE
	echo "$SCRIPT: creation du fichier \`$FLYLEAF.tex'"

cat << EOD > $FILE
% page de garde personnalisee generee le $(date)
% par $AUTHOR a l'aide du script $SCRIPT
% voir http://zoonek.free.fr/LaTeX/LaTeX_samples_title/0.html pour d'autres modeles

${BS}makeatletter
% commandes supplementaires
${BS}def${BS}location#1{${BS}def${BS}@location{#1}}
${BS}def${BS}blurb#1{${BS}def${BS}@blurb{#1}}

${BS}def${BS}clap#1{${BS}hbox to 0pt{${BS}hss #1${BS}hss}}%
${BS}def${BS}ligne#1{%
	${BS}hbox to ${BS}hsize{%
	${BS}vbox{${BS}centering #1}}%
}%
${BS}def${BS}haut#1#2#3{%
	${BS}hbox to ${BS}hsize{%
	${BS}rlap{${BS}vtop{${BS}raggedright #1}}%
	${BS}hss
	${BS}clap{${BS}vtop{${BS}centering #2}}%
	${BS}hss
	${BS}llap{${BS}vtop{${BS}raggedleft #3}}}%
}%
${BS}def${BS}bas#1#2#3{%
	${BS}hbox to ${BS}hsize{%
	${BS}rlap{${BS}vbox{${BS}raggedright #1}}%
	${BS}hss
	${BS}clap{${BS}vbox{${BS}centering #2}}%
	${BS}hss
	${BS}llap{${BS}vbox{${BS}raggedleft #3}}}%
}%
${BS}def${BS}maketitle{%
	${BS}thispagestyle{empty}${BS}vbox to ${BS}vsize{%
		${BS}haut{}{${BS}@blurb}{}
		${BS}vfill
		${BS}vspace{1cm}
		${BS}begin{flushleft}
		${BS}usefont{OT1}{ptm}{m}{n}
		${BS}huge ${BS}@title
		${BS}end{flushleft}
		${BS}par
		${BS}hrule height 4pt
		${BS}par
		${BS}begin{flushright}
		${BS}Large ${BS}@author
		${BS}par
		${BS}end{flushright}
		${BS}vspace{1cm}
		${BS}vfill
		${BS}vfill
		${BS}bas{}{${BS}@location, ${BS}@date}{}
	}%
	${BS}cleardoublepage
}
${BS}makeatother
EOD
fi

# creation du fichier tex
FILE="$OUTPUTDIR/$TEXFILENAME.tex"
touch $FILE
echo "$SCRIPT: creation du fichier \`$TEXFILENAME.tex'"

cat << EOD > $FILE
% squelette LaTeX genere le $(date)
% par $AUTHOR a l'aide du script $SCRIPT

%%%%%%%%%%%%%
% PREAMBULE %
%%%%%%%%%%%%%

EOD

if [ "$CLASS" = "beamer" ] ; then
cat << EOD > $FILE
% http://latex-beamer.sourceforge.net/
% http://www.tex.ac.uk/tex-archive/macros/latex/contrib/beamer/doc/beameruserguide.pdf

${BS}documentclass{$CLASS}
${BS}usepackage[utf8]{inputenc}                     % encodage du fichier (utf8 ou latin1)
${BS}usepackage[francais]{babel}                    % langue
${BS}usetheme{Warsaw}
EOD
else
cat << EOD > $FILE
${BS}documentclass[a4paper, 11pt]{$CLASS}           % format general

${BS}usepackage[T1]{fontenc}                        % codage des caracteres
${BS}usepackage[utf8]{inputenc}                     % encodage du fichier (utf8 ou latin1)
${BS}usepackage[francais]{babel}                    % langue
${BS}usepackage{lmodern}                            % selection de la police
${BS}usepackage{geometry}                           % mise en page
${BS}geometry{top=2.5cm, bottom=2.5cm, left=2cm, right=2cm}
${BS}usepackage{xcolor}                             % pour colorer des elements
EOD
fi

$MATH && cat << EOD >> $FILE
${BS}usepackage{amssymb}                            % symboles mathematiques
%${BS}usepackage{amsmath}                           % commandes mathematiques
EOD

$GRAPHICS && cat << EOD >> $FILE
${BS}usepackage{graphicx}                           % pour inserer des images
${BS}graphicspath{{$GRAPHICS_PATH}}                 % chemins vers les images
% commande pour afficher un lien vers une image
${BS}newcommand{${BS}figref}[1]{${BS}textsc{Fig.}~${BS}ref{#1} (p.~${BS}pageref{#1})}

EOD

[ "$CLASS" != "beamer" ] && $FANCYHDR && cat << EOD >> $FILE
${BS}usepackage{lastpage}                           % derniere page
${BS}usepackage{fancyhdr}                           % en-tete et pied de page
${BS}pagestyle{fancy}
${BS}lhead{$TITLE}
${BS}chead{}
${BS}rhead{${BS}thepage/${BS}pageref{LastPage}}
${BS}lfoot{}
${BS}cfoot{}
${BS}rfoot{${BS}footnotesize $AUTHOR}
%${BS}renewcommand{${BS}headrulewidth}{0pt}
%${BS}renewcommand{${BS}footrulewidth}{0.4pt}
${BS}fancypagestyle{plain}{%                        % style des pages de titres
	${BS}fancyhf{}
	${BS}renewcommand{${BS}headrulewidth}{0pt}
	${BS}renewcommand{${BS}footrulewidth}{0pt}
}

EOD

[ "$CLASS" != "beamer" ] && $PDF && cat << EOD >> $FILE
${BS}usepackage{url}                                % permet l'insertion d'url
${BS}usepackage[pdftex]{hyperref}                   % permet l'hypertexte (rend les liens cliquables)
${BS}hypersetup{%
	pdftitle    = {$TITLE},
	pdfauthor   = {$AUTHOR}
        pdfcreator  = {Texlive},
        pdfproducer = {Texlive},
        colorlinks  = true,
        linkcolor   = black,
	citecolor   = black,
	urlcolor    = black
}                                                   % informations du pdf

EOD

$LISTINGS && cat << EOD >> $FILE
${BS}usepackage{listings}                           % permet d'inserer du code (multi-langage)
${BS}include{$LISTINGS_CONF}                        % fichier de config du paquet listings

EOD

for thisPACKAGE in "${MORE_PACKAGES[@]}" ; do
	echo "${BS}usepackage{$thisPACKAGE}" >> $FILE
done

cat << EOD >> $FILE

% informations du document
${BS}author{$AUTHOR}
${BS}date{Le $DATE}
${BS}title{$TITLE}
EOD

[ "$CLASS" = "beamer" ] && echo "${BS}institute{}" >> $FILE
[ "$CLASS" = "report" ] && cat << EOD >> $FILE
%${BS}include{$FLYLEAF} % page de garde personnalisee
%${BS}location{}
%${BS}blurb{}

${BS}renewcommand{${BS}thesection}{${BS}Roman{part}.${BS}arabic{section}} % redefinir la numerotation des sections (ex: I.2)

${BS}newcommand{${BS}unnumchap}[1]{%
	${BS}chapter*{#1}%
	${BS}addcontentsline{toc}{chapter}{#1}%
	${BS}chaptermark{#1}%
}
EOD

if [ "$CLASS" = "beamer" ] ; then
cat << EOD >> $FILE

${BS}AtBeginSubsection[]
{
  ${BS}begin{frame}<beamer>
    ${BS}frametitle{Plan}
    ${BS}tableofcontents[currentsection,currentsubsection]
  ${BS}end{frame}
}
EOD
else
cat << EOD >> $FILE

${BS}makeatletter
${BS}@addtoreset{section}{part} % reprendre a partir de 1 les sections des parties suivantes
${BS}makeatother

%${BS}AtBeginDocument{%
%	${BS}renewcommand{${BS}abstractname}{} % renommer le resume
%}
EOD
fi

cat << EOD >> $FILE
% raccourcis

${BS}newcommand{${BS}Cad}{C'est-a-dire~}
${BS}newcommand{${BS}cad}{c'est-a-dire~}
${BS}newcommand{${BS}todo}[1]{${BS}bigskip ${BS}large ${BS}colorbox{green}{${BS}textcolor{gray}{${BS}textsf{${BS}textbf{//TODO}: ${BS}hfill #1 ${BS}hfill}}} ${BS}bigskip}
EOD

$PDF && echo "${BS}newcommand{${BS}email}[1]{${BS}href{mailto:#1}{${BS}textsf{<#1>}}}" >> $FILE

cat << EOD >> $FILE

%%%%%%%%%
% CORPS %
%%%%%%%%%

${BS}begin{document} % debut du document

EOD

if [ "$CLASS" = "beamer" ] ; then
cat << EOD >> $FILE
${BS}begin{frame}
${BS}titlepage
${BS}end{frame}

EOD
else
cat << EOD >> $FILE
${BS}maketitle % afficher le titre

% resume
${BS}begin{abstract}
${BS}end{abstract}

${BS}tableofcontents % table des matieres

EOD
fi

[ "$CLASS" != "beamer" ] && $LISTINGS && echo -e "${BS}lstlistoflistings % tables des listings\n" >> $FILE

[ "$CLASS" = "article" ] && echo "${BS}newpage" >> $FILE
[ "$CLASS" = "report" ] && echo "${BS}unnumchap{Introduction}" >> $FILE

[ "$CLASS" != "beamer" ] && cat << EOD >> $FILE

% indique que les sections suivantes sont des annexes
%${BS}appendix
EOD

cat << EOD >> $FILE

${BS}end{document} % fin du document
%EOF
EOD

# creation de l'aide-memoire pour les images si besoin
if $GRAPHICS ; then
	FILE="$OUTPUTDIR/$GRAPHICS_SUM"
	touch $FILE
	echo "$SCRIPT: creation du fichier \`$GRAPHICS_SUM'"

cat << EOD > $FILE
% aide-memoire pour l'insertion d'image sous LaTeX genere le $(date)
% par $AUTHOR a l'aide du script $SCRIPT

% [!h] est facultatif, ca permet d'indiquer la position de la figure (si possible !)
% ! = forcer la position
% h = here
% t = top
% b = bottom
% p = page separee
% si il y a un probleme avec le positionnement, il peut etre force avec la position [H] (necessite le paquet float)

${BS}begin{figure}[!h]
${BS}begin{center}
%${BS}includegraphics[width=5cm]{images/freebsd.png}
%${BS}includegraphics[height=4cm]{images/freebsd.png}
${BS}includegraphics{images/freebsd.png}
${BS}caption{${BS}label{freebsd}Logo de FreeBSD}
${BS}end{center}
${BS}end{figure}

% images cotes a cotes avec une seule legende
% note de bas de page dans un caption (${BS}footnote ne peut pas etre utilise)
${BS}begin{figure}[!h]
   ${BS}begin{center}
      ${BS}includegraphics[height=2cm]{images/freebsd.png}
      ${BS}hspace{1cm} % espace horizontal (facultatif)
      ${BS}includegraphics[height=2cm]{images/openbsd.png}
      ${BS}hspace{1cm}
      ${BS}includegraphics[height=2cm]{images/netbsd.png}
   ${BS}end{center}
   ${BS}caption{FreeBSD, OpenBSD et NetBSD${BS}protect${BS}footnotemark}
${BS}end{figure}
${BS}footnotetext{Tous des systemes d'exploitation libres.}

% images cotes a cotes avec une legende pour chaque
% si 2 images, mettre comme largeur 0.5${BS}textwidth
${BS}begin{figure}[!h]
${BS}begin{minipage}{0.33${BS}textwidth}
   ${BS}begin{center}
      ${BS}includegraphics[height=2cm]{images/freebsd.png}
      ${BS}caption{FreeBSD}
   ${BS}end{center}
${BS}end{minipage}
${BS}begin{minipage}{0.33${BS}textwidth}
   ${BS}begin{center}
      ${BS}includegraphics[height=2cm]{images/openbsd.png}
      ${BS}caption{OpenBSD}
   ${BS}end{center}
${BS}end{minipage}
${BS}begin{minipage}{0.33${BS}textwidth}
   ${BS}begin{center}
      ${BS}includegraphics[height=2cm]{images/netbsd.png}
      ${BS}caption{NetBSD}
   ${BS}end{center}
${BS}end{minipage}
${BS}end{figure}
EOD
fi

echo "$SCRIPT: OK"
exit 0

