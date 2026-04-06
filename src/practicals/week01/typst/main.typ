#import "/src/templates/practical.typ": *

#show: practical.with(
  title: "Web Application Programming Interface (API)",
  authors: ("Brae Webb", "Millie Hughes", "Richard Thomas")
)

#figure([#box(width: 50%, image("images/header.png"));])

#aside[
  Github Classroom links for this practical can be found on #edstem.
]

#teacher[
  Welcome to your first practical of CSSE6400, these teacher blocks are meant to help guide in your presentation of this material. Its recommended to read these notes ahead as they may contain timing information or little tips and tricks for common issues.
]

// todo(mh): Add GraphQL and RPC/GRPC content
// todo(mh): Add SOAP content

= This Week
#task(title: "Goals")[
  - initialise our GitHub repositories where we will be working on
    practical exercises; and
  - build a minimal HTTP API of a todo app using the FastAPI framework.
] 

= Practicals

These practicals are designed to prepare you with the technical skills required for the scalability and capstone projects. We will normally spend the first section of the practicals gaining the relevant conceptual background for the practical. The second section will be a practical exercise where you will need to write and run some code.

This semester we will create a scalable and fault-tolerant #emph[todo list] application. You need to keep up with the practicals or you will #strong[#emph[not];] be able to complete the projects.

#teacher[
  Spend approximately the first 5 minutes introducing yourself, getting to know the students, and discussing the practicals in general. Spend the next 10 minutes explaining the basic concepts of HTTP and REST.
]

#info[
  In this practical we will build a RESTful API that communicates over HTTP. It is worth noting that while this is a common way to build APIs, it is far from the only way. We will briefly explore some alternatives in subsequent weeks.
]

= Concepts

== Networking

#align(center)[
  #scale(60%)[
    #canvas({
      import draw: *

      rect((-3, 0), (3, -1.5), stroke: (paint: black, thickness: 1.2pt), name: "top")
      rect((-3.5, -2), (3.5, -3.5), stroke: (paint: black, thickness: 1.2pt))
      rect((-4, -4), (4, -5.5), stroke: (paint: black, thickness: 1.2pt))
      rect((-4.5, -6), (4.5, -7.5), stroke: (paint: black, thickness: 1.2pt))
      rect((-5, -8), (5, -9.5), stroke: (paint: black, thickness: 1.2pt))
      rect((-5.5, -10), (5.5, -11.5), stroke: (paint: black, thickness: 1.2pt))
      rect((-6, -12), (6, -13.5), stroke: (paint: black, thickness: 1.2pt))
      content((rel: (0, 0), to: "top"), [Application Layer], name: "app")
      content((rel: (0, -2), to: "app"), [Presentation Layer], name: "pres")
      content((rel: (0, -2), to: "pres"), [Session Layer], name: "sess")
      content((rel: (0, -2), to: "sess"), [Transport Layer], name: "trans")
      content((rel: (0, -2), to: "trans"), [Network Layer], name: "net")
      content((rel: (0, -2), to: "net"), [Data Link Layer], name: "data")
      content((rel: (0, -2), to: "data"), [Physical Layer])
      }
    )
  ]
]

The above diagram shows the layers of the #emph[OSI] model. These are the layers of abstraction that comprise the Internet Protocol Suite \(or, how computers communicate over the Internet).

At the transport layer, we have the #emph[Transmission Control Protocol] \(TCP) and #emph[User Datagram Protocol] \(UDP). This is a low-level protocol that you may have already used in your previous studies, this is the level of networking taught in #emph[CSSE2310];. While it is possible to develop applications that use this protocol directly, it is not very practical.

In this course we will be using the #emph[Hypertext Transfer Protocol] \(HTTP). HTTP is a higher-level protocol that is built on top of TCP, it sits in the #emph[Application Layer] of the OSI model. HTTP is the protocol that is used to transfer web pages over the Internet.

#align(center)[
  #scale(60%)[
    #canvas({
      import draw: *

      rect((-3, 0), (3, -1.5), stroke: (paint: blue, thickness: 1.2pt), name: "top")
      rect((-3.5, -2), (3.5, -3.5), stroke: (paint: gray, thickness: 1.2pt))
      rect((-4, -4), (4, -5.5), stroke: (paint: gray, thickness: 1.2pt))
      rect((-4.5, -6), (4.5, -7.5), stroke: (paint: blue, thickness: 1.2pt))
      rect((-5, -8), (5, -9.5), stroke: (paint: gray, thickness: 1.2pt))
      rect((-5.5, -10), (5.5, -11.5), stroke: (paint: gray, thickness: 1.2pt))
      rect((-6, -12), (6, -13.5), stroke: (paint: gray, thickness: 1.2pt))
      content((rel: (0, 0), to: "top"), [Application Layer], name: "app")
      content((rel: (0, -2), to: "app"), [Presentation Layer], name: "pres")
      content((rel: (0, -2), to: "pres"), [Session Layer], name: "sess")
      content((rel: (0, -2), to: "sess"), [Transport Layer], name: "trans")
      content((rel: (0, -2), to: "trans"), [Network Layer], name: "net")
      content((rel: (0, -2), to: "net"), [Data Link Layer], name: "data")
      content((rel: (0, -2), to: "data"), [Physical Layer])

      content((rel: (7, 0), to: "trans"), [#strong[TCP/UDP (CSSE2310)]])
      content((rel: (6, 0), to: "app"), [#strong[HTTP/HTTPS (CSSE6400)]])
      }
    )
  ]
]


== URLs

A #emph[Uniform Resource Locator] \(URL) is a string that identifies a
resource on the Internet.

There are three main components of a URL:

/ Protocol: The protocol used to access the resource, e.g. #emph[http] or #emph[https];.
/ Host: The host name of the server that hosts the resource, e.g. #emph[example.com] or #emph[localhost];.
/ Path: The path to the resource on the server, how the server identifies the resource.

A URL can also contain a #emph[port] number, which is the port number
that the server is listening on. If the port number is not specified,
the default port number for the protocol is used. For example, the
default port number for #emph[http] is 80, and the default port number
for #emph[https] is 443.

The URL #emph[http:\/\/example.com/hello-world] is equivalent to
#emph[http:\/\/example.com:80/hello-world];.

URLs can also contain #emph[query parameters];, which are key-value
pairs that are used to pass information to the server. Query parameters
are separated from the path by a question mark \(`?`). Each query
parameter is separated from the next by an ampersand \(`&`).

== HTTP
<http>
HTTP is a request-response abstraction for networking.

=== Request
<request>
The HTTP request is a message sent to the server. It contains the
following information:

/ URL: An endpoint to which the request is sent.
/ Method: Described later.
/ Headers: Specify type of data, e.g. JSON, HTML, etc. and other metadata about the request.
/ Body: The optional data to send to the server.

=== Response

The HTTP response is a message sent from the server. It contains the
following information:

/ Status code: A number between 100 and 599 giving details about the response.

/ Headers: Specify type of response data, e.g. JSON, HTML, etc. and other metadata
about the response.

/ Body: Content of the response.

==== Status Codes

/ 200s: Indicate the request was successful, 200 is the most common.
/ 300s: Redirects the requester to another location.
/ 400s: Indicates that the request was wrong, e.g. 404 meaning that the request
was for something that does not exist.
/ 500s: Indicates that the server had a problem fulfilling the request.


==== Methods
<methods>
/ GET: Queries the server for information.


/ POST: Creates a new resource on the server.


/ PUT: Updates an existing resource on the server.


/ DELETE: Deletes an existing resource on the server.


== JSON

JavaScript Object Notation \(JSON) is a data format commonly used to pass data to an API. It is fairly succinct and communicates the important points to a human reader better than some alternative formats. The popularity of JSON is largely due to its compatibility with JavaScript which has taken over as the defacto web development language. JSON is the map-esque data type in JavaScript. Detractors of JSON claim that its main disadvantage compared to XML \(an alternative data format) is that it lacks a schema. However, they are optional, just as in XML, but are used much less than in XML.

#codly(header: [#icon("ph:file", width: 1em, y: -0.15em) csse6400.json])
```json
{
    "Course Code": "CSSE6400",
    "Course Title": "Software Architecture"
}
```

== REST
<rest>
REST is an architectural style guided by a set of architectural
constraints that allows us to build flexible APIs. In this course we do
not dive too deep into the architectural style and instead opt for a
more surface level understanding. It is a common mistake for people to
refer to REST as a HTTP based web service API, they are different. In
this course we chose to embrace this mistake and often refer to a HTTP
based web service API when saying REST.

An example of this type of API might be:

/ GET /api/v1/todo: #block[
List all tasks todo
]

/ POST /api/v1/todo: #block[
Create a task todo
]

/ GET /api/v1/todo/id: #block[
List all details about a certain task
]

/ PUT /api/v1/todo/id: #block[
Update the fields of an existing task
]

/ DELETE /api/v1/todo/id: #block[
Delete a specific task
]

Note that the API specification does not include details of the port or
hostname, as these may change frequently.

= GitHub
<github>
We will use GitHub to host our practical work. This is strongly
encouraged as it will help you to get experience with the assessment
submission process. Additionally, committing your work regularly is a
good habit to get into and will be useful for your future career.

== Creating a GitHub Account
<creating-a-github-account>
If you do not already have a GitHub account, you will need to create
one. You can do this by visiting #link("https://github.com/join");.

== Joining the Course Organisation
<joining-the-course-organisation>
Once you have created an account, you will need to join the course
organisation. If you have not yet filled out the , you will need to do
so before you can join the organisation. The link to the form can also
be found on Blackboard.

Once you have filled out the form, tell your tutor your GitHub username
and they will add you to the organisation.

== Joining the GitHub Classroom
<joining-the-github-classroom>
Once you have joined the organisation, you will need to join the GitHub
Classroom. Follow the link at the top of this worksheet to join the
classroom.

== Creating a Practical Repository
<creating-a-practical-repository>
Navigate to the GitHub Classroom link. You should see a list of
practicals, click on the week one practical. This will create a new
repository for you in the course organisation. You can clone this
repository to your local machine or work directly in the browser with
GitHub Codespaces.

= TODO App
<todo-app>
== The API design
<the-api-design>
=== GET /api/v1/health
<get-apiv1health>
This endpoint should return a 200 status code and a JSON object with a
single field, #strong[status];, which should be set to #strong[ok];.

```http
GET /api/v1/health HTTP/1.1

HTTP/1.1 200 OK 
Content-Type: application/json

{ 
  "status": "ok" 
}
```

=== GET /api/v1/todos
<get-apiv1todos>
This endpoint should return a list of all the tasks in the todo list.

Optional query parameters:

- #strong[completed] A boolean value indicating whether to return
  completed tasks or not. Valid values are `true` or `false`.

- #strong[window] An integer value indicating how many days past today's
  date a task should be due by.

```http
GET /api/v1/todos?completed=true&window=7 HTTP/1.1

HTTP/1.1 200 OK
Content-Type: application/json

[
    {
      "id": 1,
      "title": "Watch CSSE6400 Lecture",
      "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
      "completed": true,
      "deadline_at": "2026-02-27T18:00:00",
      "created_at": "2026-02-20T14:00:00",
      "updated_at": "2026-02-20T14:00:00"
    },
    ...
]
```
=== GET /api/v1/todos/
<get-apiv1todos-1>
This endpoint should return a single item from the todo list.

```http
GET /api/v1/todos/1 HTTP/1.1

HTTP/1.1 200 OK
Content-Type: application/json

{
    "id": 1,
    "title": "Watch CSSE6400 Lecture",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": false,
    "deadline_at": "2026-02-27T18:00:00",
    "created_at": "2026-02-20T14:00:00",
    "updated_at": "2026-02-20T14:00:00"
}
```

=== POST /api/v1/todos
<post-apiv1todos>
This endpoint should create a new task in the todo list. The title field
must be included in the request and all other values are optional. The
`created_at`, `updated_at` cannot be set by this method.

Attempting to post any other fields than
`title, description, completed, deadline_at` will cause a 400 error to
be returned.

```http
POST /api/v1/todos HTTP/1.1
Content-Type: application/json

{
    "title": "Watch CSSE6400 Lecture",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": false,
    "deadline_at": "2026-02-27T18:00:00",
}

HTTP/1.1 201 Created
Content-Type: application/json

{
    "id": 1,
    "title": "Watch CSSE6400 Lecture",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": false,
    "deadline_at": "2026-02-27T18:00:00",
    "created_at": "2026-02-20T14:00:00",
    "updated_at": "2026-02-20T14:00:00"
}
```
=== PUT /api/v1/todos/
<put-apiv1todos>
This endpoint should update a task in the todo list. The `created_at`,
`updated_at` cannot be set by this method.

Attempting to put any other fields than
`title, description, completed, deadline_at` will cause a 400 error to
be returned.

Attempting to put a task id that does not exist will cause a 404 error
to be returned.

```http
PUT /api/v1/todos/1 HTTP/1.1
Content-Type: application/json

{
    "title": "Join the Richard Thomas fan club",
}

HTTP/1.1 200 OK
Content-Type: application/json

{
    "id": 1,
    "title": "Join the Richard Thomas fan club",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": false,
    "deadline_at": "2026-02-27T18:00:00",
    "created_at": "2026-02-20T14:00:00",
    "updated_at": "2026-02-20T14:00:00"
}
```
=== DELETE /api/v1/todos/
<delete-apiv1todos>
This endpoint should delete a task from the todo list. If the task does
not exist, a 200 is returned with an empty response.

```http
DELETE /api/v1/todos/1 HTTP/1.1

HTTP/1.1 200 OK
Content-Type: application/json

{
    "id": 1,
    "title": "Join the Richard Thomas fan club",
    "description": "Watch the CSSE6400 lecture on ECHO360 for week 1",
    "completed": false,
    "deadline_at": "2026-02-27T18:00:00",
    "created_at": "2026-02-20T14:00:00",
    "updated_at": "2026-02-20T14:00:00"
}
```

== Implementation with FastAPI



