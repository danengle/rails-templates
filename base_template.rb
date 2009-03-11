run "touch public/stylesheets/styles.css"
run "cp config/database.yml condig/database.yml.example"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

if yes?("Would you like to create a mysql development database?")
  run "mysqladmin -u root create #{@root.split('/').last}_development"
end

run "echo TODO > README"
run "rm public/index.html"

plugin "will_paginate", :git => "git://github.com/engled68/will_paginate.git"
plugin "rspec", :git => "git://github.com/dchelimsky/rspec.git"
plugin "rspec-rails", :git => "git://github.com/dchelimsky/rspec-rails.git"
plugin "aasm", :git => "git://github.com/rubyist/aasm.git"
plugin "restful-authentication", :git => "git://github.com/technoweenie/restful-authentication.git"
plugin "exception_notification", :git => "git://github.com/rails/exception_notification.git"

if yes?("Do you want to use query_reviewer?")
  plugin "query_reviewer", :git => "git://github.com/dsboulder/query_reviewer.git"
end

generate :rspec
generate :authenticated, "user sessions --include-activation --aasm --rspec"

generate :controller, "welcome index"
route "map.root :controller => 'welcome'"

# reset css from http://meyerweb.com/eric/thoughts/2007/05/01/reset-reloaded/
file "public/stylesheets/reset.css", <<-END
html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, font, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	font-weight: inherit;
	font-style: inherit;
	font-size: 100%;
	font-family: inherit;
	vertical-align: baseline;
}
/* remember to define focus styles! */
:focus {
	outline: 0;
}
body {
	line-height: 1;
	color: black;
	background: white;
}
ol, ul {
	list-style: none;
}
/* tables still need 'cellspacing="0"' in the markup */
table {
	border-collapse: separate;
	border-spacing: 0;
}
caption, th, td {
	text-align: left;
	font-weight: normal;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: "";
}
blockquote, q {
	quotes: "" "";
}

END

run "curl http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery-1.3.2.min.js"

file "app/views/layouts/application.html.erb", <<-END
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
  <title><%= controller.controller_name %>: <%= controller.action_name %></title>
  <%= javascript_include_tag "jquery-1.3.2.min.js", "application" %>
  <%= stylesheet_link_tag "reset", "styles" %>
</head>
<body>

<p style="color: green"><%= flash[:notice] %></p>

<%= yield  %>

</body>
</html>
END

git :init

file ".gitignore", <<-END
.DS_STORE
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

git :add => ".", :commit => "-m 'initial commit'"