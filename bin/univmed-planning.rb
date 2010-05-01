#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'

user = ''
password = ''
dept = 'irm2'
demi = 1
group = 2
option = 'SICA'

agent = Mechanize.new

# authenticate
page = agent.get('https://auth.univmed.fr/login?service=http%3A%2F%2Fplanning.univmed.fr%2Fade%2Fstandard%2Fgui%2Finterface.jsp')
auth_form = page.forms.first
auth_form.username = user
auth_form.password = password
agent.submit(auth_form, auth_form.buttons.first)

# select project (i.e. "Universite 2009/2010")
page = agent.get('http://planning.univmed.fr/ade/standard/projects.jsp')
agent.submit(page.forms.first)

pp agent.get('http://planning.univmed.fr/ade/standard/gui/interface.jsp')
# why does it seem to be empty?

# TODO type dept into search field, then click search button
# TODO click on link with corresponding text, i.e.:
# page.link_with(:text => "IRM2 #{option}")[1].click

exit
