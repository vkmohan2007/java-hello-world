<html>
<head>
<title>Hello World!</title>
</head>
<body>
	<h1>Hello World!</h1>
<p>This is java application!! build with Jenkins, Sonarqube, Trivy, Docker, Prometheus, Grafana...</p>
	<p>
		It is now
		<%= new java.util.Date() %></p>
	<p>
		You are coming from 
		<%= request.getRemoteAddr()  %></p>
</body>
