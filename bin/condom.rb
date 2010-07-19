#!/usr/bin/ruby -w

#TODO Split author with space to get firstname and lastname

require 'etc'
require 'erb'
require 'optparse'
#require 'yaml'

version = 1.6
$today = Time.now.strftime("%d %B %Y")

user = Etc.getpwnam(Etc.getlogin)['gecos'].split(',')[0]
user = Etc.getlogin if user.nil?
$options = {
    :outputdir => Dir.getwd,
    :listings? => false,
    :fancyhdr? => false,
    :graphics? => false,
    :math?     => false,
    :pdf?      => false,
    :filename  => 'main',
    :author    => user,
    :title     => 'Document \LaTeX',
    :date      => '\today',
    :class     => 'article',
    :packages  => []
}

class String
    def >> str
        str.insert(0, self)
    end
end

def echo str
    puts "condom: " << str
end

def touch file, template
    echo "creation de #{file}"
    content = ERB.new(template).result
    f = File.open(file, 'w')
    f.write content
    f.close
end

def print_values
    printf("%-10s%-26s%s\n", "option :", "attribut :", "valeur :")
    puts "--------------------------------------------"
    printf("%-10s%-26s%s", "", "destination", $options[:outputdir])
    puts $options[:outputdir] == Dir.getwd ? " (dossier courant)" : ""
    printf("%-10s%-26s", "-m", "math")
    puts $options[:math?] ? "oui" : "non"
    printf("%-10s%-26s", "-l", "listings")
    puts $options[:listings?] ? "oui, dossier #{$options[:outputdir]}/src" : "non"
    printf("%-10s%-26s", "-f", "fancyhdr")
    puts $options[:fancyhdr?] ? "oui" : "non"
    printf("%-10s%-26s", "-p", "config pdf")
    puts $options[:pdf?] ? "oui" : "non"
    printf("%-10s%-26s", "-i", "images")
    puts $options[:graphics?] ? "oui, dossier #{$options[:outputdir]}/fig" : "non"
    printf("%-10s%-26s%s\n", "-n", "nom du fichier", $options[:filename])
    printf("%-10s%-26s%s\n", "-a", "auteur", $options[:author])
    printf("%-10s%-26s%s\n", "-t", "titre", $options[:title])
    printf("%-10s%-26s%s", "-d", "date", $options[:date])
    puts $options[:date] == '\today' ? " (" + $today + ")" : ""
    printf("%-10s%-26s%s\n", "-c", "classe", $options[:class])
    printf("%-10s%-26s", "-P", "paquets supplementaires")
    puts $options[:packages].empty? ? "aucun" : "oui: " + $options[:packages].join(", ")
end

ARGV.options do |o|
    o.banner = "Utilisation : #{File.basename $0} [options] [destination]"
    o.on_head("Options possibles (+ valeurs par defaut) :")

    o.on("-m", "--math", "Paquets mathematiques",
        $options[:math?] ? "oui" : "non") { $options[:math?] = true }
    o.on("-l", "--listings", "Paquet Listings",
        $options[:listings?] ? "oui" : "non") { $options[:listings?] = true }
    o.on("-f", "--fancyhdr", "Paquet Fancyhdr",
        $options[:fancyhdr?] ? "oui" : "non") { $options[:fancyhdr?] = true }
    o.on("-p", "--pdf", "Configuration pdf",
        $options[:pdf?] ? "oui" : "non") { $options[:pdf?] = true }
    o.on("-g", "--graphics", "Paquets pour images",
        $options[:graphics?] ? "oui" : "non") { $options[:graphics?] = true }
    o.on("-n", "--filename=FILENAME", String, "Definir un nom de fichier",
        $options[:filename]) { |v| $options[:filename] = v }
    o.on("-a", "--author=AUTHOR", String, "Definir l'auteur",
        $options[:author]) { |v| $options[:author] = v }
    o.on("-t", "--title=TITLE", String, "Definir le titre",
        $options[:title]) { |v| $options[:title] = v }
    o.on("-d", "--date=DATE", String, "Definir la date",
        $options[:date] + ($options[:date] == '\today' ? " (" + $today + ")" : "")) { |v| $options[:date] = v }
    o.on("-c", "--class=CLASS", String, "Definir la classe",
        $options[:class]) { |v| $options[:class] = v }
    o.on("-P", "--package=PACKAGE", String, "Ajouter un paquet",
        $options[:packages].empty? ? "aucun" : "oui: " + $options[:packages].join(", ")) { |v| $options[:packages].push v }
    o.on("-v", "--version",  "Afficher la version",
        version.to_s) { echo "version #{version}" ; exit }

    o.on_tail("destination :\n    " << $options[:outputdir] + ($options[:outputdir] == Dir.getwd ? " (dossier courant)" : ""))
end.parse!

if ARGV.length > 1
    echo "Mauvaise syntaxe."
    exit
elsif ARGV.length == 1
    $options[:outputdir] = (ARGV.first == ".") ? Dir.getwd : ARGV.first.chomp("/")
    Dir.getwd >> "/" >> $options[:outputdir] unless $options[:outputdir].chars.first == "/"
end

# demander confirmation
#print_values
#puts $options.to_yaml
#print "\nVoulez-vous continuer [Y/n/h] ? "
#case STDIN.gets.strip
#when 'Y', 'y', ''
#when 'h'
#    puts ARGV.options
#    exit
#else
#    echo "Abandon."
#    exit
#end

# verifier la destination
if File.directory? $options[:outputdir]
    Dir.chdir $options[:outputdir] unless $options[:outputdir] == Dir.getwd
    if File.exist? "main.tex"
        echo "#{$options[:outputdir]}: il existe deja un fichier main.tex"
        exit
    elsif File.exist? "Makefile"
        echo "#{$options[:outputdir]}: il existe deja un Makefile"
        exit
    end
else
    Dir.mkdir $options[:outputdir]
    Dir.chdir $options[:outputdir]
end

# creation des templates
# makefile
makefile_tpl = %q{
# Makefile genere le <%= $today %>
# par <%= $options[:author] %> a l'aide du script condom

FINAL_FILENAME=<%= $options[:filename] %>
FILENAME=main
VIEWER=xdg-open
RUBBER=$(shell which rubber)

all: $(FILENAME).tex
ifeq ($(RUBBER),)
	@pdflatex $(FILENAME).tex
	@pdflatex $(FILENAME).tex
	@echo -e "\nIl est conseillé d'installer le paquet rubber."
else
	@$(RUBBER) -d $(FILENAME).tex
endif
ifneq ($(FILENAME),$(FINAL_FILENAME))
	@mv $(FILENAME).pdf $(FINAL_FILENAME).pdf
endif

view: all
	@$(VIEWER) $(FINAL_FILENAME).pdf

clean:
	@echo "cleaning..."
	@rm -f *.aux *.log *.out *.toc *.lol<% if $options[:listings?] %> *.lof<% end %><% if $options[:class] == "beamer" %> *.nav *.snm<% end %><% unless $options[:class] == "beamer" %>
	@rm -f inc/*.aux<% end %>
	@rm -f $(FINAL_FILENAME).tar

archive: all clean
	@tar -cf $(FINAL_FILENAME).tar *
	@echo "archived in $(FINAL_FILENAME).tar"
}.strip

# liste des packages
packages_tpl = %q{
\usepackage[T1]{fontenc}      % codage des caracteres
\usepackage[utf8]{inputenc}   % encodage du fichier (utf8 ou latin1)
\usepackage[francais]{babel}  % langue
\usepackage{mathpazo}         % selection de la police
\usepackage{geometry}         % mise en page
\usepackage{xcolor}           % pour colorer des elements

<% if $options[:graphics?] %>
\usepackage{graphicx}         % pour inserer des images
<% end %>

<% if $options[:math?] %>
% math
\usepackage{amssymb}          % symboles mathematiques
%\usepackage{amsmath}         % commandes mathematiques
<% end %>

<% if $options[:pdf?] %>
% pdf
\usepackage{url}              % permet l'insertion d'url
\usepackage[pdftex]{hyperref} % permet l'hypertexte (rend les liens cliquables)
<% end %>

<% if $options[:listings?] %>
% listings
\usepackage{listings}         % permet d'inserer du code (multi-langage)
\usepackage{courier}
\usepackage{caption}
<% end %>

<% if $options[:fancyhdr?] %>
% fancyhdr
\usepackage{lastpage}         % derniere page
\usepackage{fancyhdr}         % en-tete et pied de page
<% end %>

\usepackage{multicol}
<% $options[:packages].each { |p| puts '\usepackage{' << p << '}' } %>
}.strip

# liste des couleurs
colors_tpl = %q{
%         Colors    Bright Colors
% Black   #0F2130   #B0B3B9
% Red     #D22613   #F96795
% Green   #7CDE53   #A0F2A0
% Yellow  #EBE645   #F4EF82
% Blue    #2C9ADE   #A3FEFE
% Orange  #FFA705   #F1B356
% Cyan    #8A95A7   #B0C3DA
% White   #F8F8F8   #FFFFFF

\definecolor{myblack}{HTML}{0F2130}
\definecolor{myred}{HTML}{D22613}
\definecolor{mygreen}{HTML}{7CDE53}
\definecolor{myyellow}{HTML}{EBE645}
\definecolor{myblue}{HTML}{2C9ADE}
\definecolor{myorange}{HTML}{FFA705}
\definecolor{mycyan}{HTML}{8A95A7}
\definecolor{mywhite}{HTML}{F8F8F8}
\definecolor{mygrey}{HTML}{555753}
}.strip

# liste des commandes perso
commands_tpl = %q{
% raccourcis
\newcommand{\Cad}{C'est-à-dire~}
\newcommand{\cad}{c'est-à-dire~}
\newcommand{\pe}{peut-être~}

\newcommand{\todo}[1]{\bigskip \colorbox{myyellow}{\textcolor{mygrey}{\textsf{\textbf{TODO} #1 }}} \bigskip}

\newcommand{\name}[2]{#1 \textsc{#2}}

<% if $options[:pdf?] %>
\newcommand{\email}[1]{\href{mailto:#1}{\textsf{<#1>}}}
<% end %>

<% if $options[:graphics?] %>
% commande pour afficher un lien vers une image
\newcommand{\figref}[1]{\textsc{Fig.}~\ref{#1} (p.~\pageref{#1})}
<% end %>

<% if $options[:listings?] %>
% commande pour afficher le lien vers un listing :
\newcommand{\lstref}[1]{{\footnotesize Listing~\ref{#1}, p.~\pageref{#1}}}
<% end %>

<% if $options[:class] == "report" %>
\newcommand{\unnumchap}[1]{%
    \chapter*{#1}%
    \addcontentsline{toc}{chapter}{#1}%
    \chaptermark{#1}%
}

\newcommand{\unnumpart}[1]{%
    \part*{#1}%
    \addcontentsline{toc}{part}{#1}%
}
<% end %>
}.strip

# fichier de config pour listings
listings_tpl = %q{
% fichier de config du paquet listings genere le <%= $today %>
% par <%= $options[:author] %> a l'aide du script condom
%
% /!\ ne pas utiliser de caracteres accentues dans les sources (ne gere pas l'utf-8)
% pour remplacer les lettres accentues : sed -i -e "y/ÉÈÊÇÀÔéèçàôîêûùï/EEECAOeecaoieuui/" fichier

% configuration des listings par defaut :
\lstset{
    basicstyle=\footnotesize\ttfamily,
    %numbers=left,
    numberstyle=\tiny,
    %stepnumber=2,
    numbersep=5pt,
    tabsize=2,
    extendedchars=true,
    breaklines=true,
    frame=b,
    keywordstyle=\color{red},
    %keywordstyle=[1]\textbf,
    %keywordstyle=[2]\textbf,
    %keywordstyle=[3]\textbf,
    %keywordstyle=[4]\textbf,
    stringstyle=\color{white}\ttfamily,
    showspaces=false,
    showtabs=false,
    xleftmargin=17pt,
    framexleftmargin=17pt,
    framexrightmargin=5pt,
    framexbottommargin=4pt,
    %backgroundcolor=\color{lightgray},
    showstringspaces=false
}

\lstloadlanguages{
    %[Visual]Basic
    %Pascal
    %C
    %C++
    %XML
    %HTML
    %Java
}
%\DeclareCaptionFont{blue}{\color{blue}}

%\captionsetup[lstlisting]{singlelinecheck=false, labelfont={blue}, textfont={blue}}
\DeclareCaptionFont{white}{\color{white}}
\DeclareCaptionFormat{listing}{\colorbox[cmyk]{0.43, 0.35, 0.35,0.01}{\parbox{\textwidth}{\hspace{15pt}#1#2#3}}}
\captionsetup[lstlisting]{format=listing,labelfont=white,textfont=white, singlelinecheck=false, margin=0pt, font={bf,footnotesize}}

% configuration des listings C :
\lstnewenvironment{C}
{\lstset{%
    language=C,
    tabsize=3,
    xleftmargin=0.75cm,
    numbers=left,
    numberstyle=\tiny,
    extendedchars=true,
    %frame=single,
    %frameround=tttt,
    framexleftmargin=8mm,
    float,
    showstringspaces=true,
    showspaces=false,
    showtabs=false,
    breaklines=true,
    backgroundcolor=\color{mywhite},
    basicstyle=\color{myblack} \small,
    keywordstyle=\color{myred} \bfseries,
    ndkeywordstyle=\color{myred} \bfseries,
    commentstyle=\color{myblue} \itshape,
    identifierstyle=\color{myyellow},
    stringstyle=\color{mygreen}
}}
{}

% configuration des listings console :
\lstnewenvironment{console}
{\lstset{%
    language={},
    numbers=none,
    extendedchars=true,
    framexleftmargin=5mm,
    %float,
    showstringspaces=false,
    showspaces=false,
    showtabs=false,
    breaklines=false,
    backgroundcolor=\color{darkgray},
    basicstyle=\color{white} \scriptsize \ttfamily,
    keywordstyle=\color{white},
    ndkeywordstyle=\color{white},
    commentstyle=\color{white},
    identifierstyle=\color{white},
    stringstyle=\color{white}
}}
{}

\renewcommand{\lstlistlistingname}{Table des codes sources} % renommer la liste des listings

% un listing depuis un fichier s'importe comme ceci :
%\lstinputlisting[caption={Legende}, label=lst:label]{emplacement}
}.strip

# page de garde personnalisee
flyleaf_tpl = %q{
% page de garde personnalisee generee le <%= $today %>
% par <%= $options[:author] %> a l'aide du script condom
% voir http://zoonek.free.fr/LaTeX/LaTeX_samples_title/0.html pour d'autres modeles

\makeatletter
% commandes supplementaires
\def\location#1{\def\@location{#1}}
\def\blurb#1{\def\@blurb{#1}}

\def\clap#1{\hbox to 0pt{\hss #1\hss}}%
\def\ligne#1{%
    \hbox to \hsize{%
    \vbox{\centering #1}}%
}%
\def\haut#1#2#3{%
    \hbox to \hsize{%
    \rlap{\vtop{\raggedright #1}}%
    \hss
    \clap{\vtop{\centering #2}}%
    \hss
    \llap{\vtop{\raggedleft #3}}}%
}%
\def\bas#1#2#3{%
    \hbox to \hsize{%
    \rlap{\vbox{\raggedright #1}}%
    \hss
    \clap{\vbox{\centering #2}}%
    \hss
    \llap{\vbox{\raggedleft #3}}}%
}%
\def\maketitle{%
    \thispagestyle{empty}\vbox to \vsize{%
        \haut{}{\@blurb}{}
        \vfill
        \vspace{1cm}
        \begin{flushleft}
        \usefont{OT1}{ptm}{m}{n}
        \huge \@title
        \end{flushleft}
        \par
        \hrule height 4pt
        \par
        \begin{flushright}
        \Large \@author
        \par
        \end{flushright}
        \vspace{1cm}
        \vfill
        \vfill
        \bas{}{\@location, \@date}{}
    }%
    \cleardoublepage
}
\makeatother
}.strip

# aide-memoire pour les images
graphics_sum_tpl = %q{
% aide-memoire pour l'insertion d'image sous LaTeX genere le <%= Time.now %>
% par <%= $options[:author] %> a l'aide du script condom

% [!h] est facultatif, ca permet d'indiquer la position de la figure (si possible !)
% ! = forcer la position
% h = here
% t = top
% b = bottom
% p = page separee
% si il y a un probleme avec le positionnement, il peut etre force avec la position [H] (necessite le paquet float)

\begin{figure}[!h]
\begin{center}
%\includegraphics[width=5cm]{images/freebsd.png}
%\includegraphics[height=4cm]{images/freebsd.png}
\includegraphics{images/freebsd.png}
\caption{\label{freebsd}Logo de FreeBSD}
\end{center}
\end{figure}

% images cotes a cotes avec une seule legende
% note de bas de page dans un caption (\footnote ne peut pas etre utilise)
\begin{figure}[!h]
   \begin{center}
      \includegraphics[height=2cm]{images/freebsd.png}
      \hspace{1cm} % espace horizontal (facultatif)
      \includegraphics[height=2cm]{images/openbsd.png}
      \hspace{1cm}
      \includegraphics[height=2cm]{images/netbsd.png}
   \end{center}
   \caption{FreeBSD, OpenBSD et NetBSD\protect\footnotemark}
\end{figure}
\footnotetext{Tous des systemes d'exploitation libres.}

% images cotes a cotes avec une legende pour chaque
% si 2 images, mettre comme largeur 0.5\textwidth
\begin{figure}[!h]
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/freebsd.png}
      \caption{FreeBSD}
   \end{center}
\end{minipage}
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/openbsd.png}
      \caption{OpenBSD}
   \end{center}
\end{minipage}
\begin{minipage}{0.33\textwidth}
   \begin{center}
      \includegraphics[height=2cm]{images/netbsd.png}
      \caption{NetBSD}
   \end{center}
\end{minipage}
\end{figure}
}.strip

# fichier tex principal
main_tpl = ""
if $options[:class] == "beamer"
main_tpl = %q{
% squelette LaTeX genere le <%= $today %>
% par <%= $options[:author] %> a l'aide du script condom

%%%%%%%%%%%%%
% PREAMBULE %
%%%%%%%%%%%%%

% http://latex-beamer.sourceforge.net/
% http://www.tex.ac.uk/tex-archive/macros/latex/contrib/beamer/doc/beameruserguide.pdf

\documentclass{beamer}
\usetheme{Warsaw}

\input{inc/packages}
\input{inc/colors}
\input{inc/commands}
<% if $options[:listings?] %>
\input{inc/lst-conf}                        % fichier de config du paquet listings
<% end %>

<% if $options[:graphics?] %>
\graphicspath{{fig/}}                 % chemins vers les images
<% end %>

% informations du document
\author{<%= $options[:author] %>}
\date{Le <%= $options[:date] %>}
\title{<%= $options[:title] %>}
\institute{}

\AtBeginSubsection[]
{
  \begin{frame}<beamer>
    \frametitle{Plan}
    \tableofcontents[currentsection,currentsubsection]
  \end{frame}
}

%%%%%%%%%
% CORPS %
%%%%%%%%%

\begin{document} % debut du document

\begin{frame}
\titlepage
\end{frame}

\end{document} % fin du document
%EOF
}.strip
else
main_tpl = %q{
% squelette LaTeX genere le <%= $today %>
% par <%= $options[:author] %> a l'aide du script condom

%%%%%%%%%%%%%
% PREAMBULE %
%%%%%%%%%%%%%

\documentclass[a4paper, 11pt]{<%= $options[:class] %>}           % format general

\input{inc/packages}
\input{inc/colors}
\input{inc/commands}
<% if $options[:listings?] %>
\input{inc/lst-conf}                        % fichier de config du paquet listings
<% end %>

\geometry{top=2.5cm, bottom=2.5cm, left=2cm, right=2cm}
<% if $options[:graphics?] %>
\graphicspath{{fig/}}                 % chemins vers les images
<% end %>

% informations du document
\author{<%= $options[:author] %>}
\date{Le <%= $options[:date] %>}
\title{<%= $options[:title] %>}

<% if $options[:class] == "report" %>
%\input{inc/flyleaf.tex} % page de garde personnalisee
%\location{}
%\blurb{}
<% end %>

<% if $options[:pdf?] %>
\hypersetup{%
    pdftitle    = {<%= $options[:title] %>},
    pdfauthor   = {<%= $options[:author] %>}
    pdfcreator  = {Texlive},
    pdfproducer = {Texlive},
    colorlinks  = true,
    linkcolor   = black,
    citecolor   = black,
    urlcolor    = black
}                                                   % informations du pdf
<% end %>

<% if $options[:fancyhdr?] %>
\pagestyle{fancy}
\lhead{<%= $options[:title] %>}
\chead{}
\rhead{\thepage/\pageref{LastPage}}
\lfoot{}
\cfoot{}
\rfoot{\footnotesize <%= $options[:author] %>}
%\renewcommand{\headrulewidth}{0pt}
%\renewcommand{\footrulewidth}{0.4pt}
\fancypagestyle{plain}{%                        % style des pages de titres
    \fancyhf{}
    \renewcommand{\headrulewidth}{0pt}
    \renewcommand{\footrulewidth}{0pt}
}
<% end %>

<% if $options[:class] == "report" %>
\renewcommand{\thesection}{\Roman{part}.\arabic{section}} % redefinir la numerotation des sections (ex: I.2)
<% end %>

\makeatletter
\@addtoreset{section}{part} % reprendre a partir de 1 les sections des parties suivantes
\makeatother

%\AtBeginDocument{%
%   \renewcommand{\abstractname}{} % renommer le resume
%}

%%%%%%%%%
% CORPS %
%%%%%%%%%

\begin{document} % debut du document

\maketitle % afficher le titre

% resume
\begin{abstract}
\end{abstract}

\tableofcontents % table des matieres

<% if $options[:listings?] %>
\lstlistoflistings % tables des listings
<% end %>

<% if $options[:class] == "article" %>
\newpage
<% elsif $options[:class] == "report" %>
\unnumpart{Introduction}
<% end %>

\end{document} % fin du document
%EOF
}.strip
end

# creation des fichiers
touch "main.tex", main_tpl
touch "Makefile", makefile_tpl
if $options[:graphics?]
    touch "fig.tex.txt", graphics_sum_tpl
    Dir.mkdir "fig"
end
Dir.mkdir "src" if $options[:listings?]
Dir.mkdir "inc"
Dir.chdir "inc"
touch "packages.tex", packages_tpl
touch "commands.tex", commands_tpl
touch "colors.tex", colors_tpl
touch "lst-conf.tex", listings_tpl if $options[:listings?]
touch "flyleaf.tex", flyleaf_tpl if $options[:class] == "report"

echo "OK"
exit
