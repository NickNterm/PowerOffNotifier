
# Deddhe Custom Notifier App

This is a small personal project that help everyone to get notification from the site: https://siteapps.deddie.gr/Outages2Public

In this project i used: Flutter, FastAPI, Python

## Authors

- [@nicknterm](https://www.github.com/nicknterm)


## API Reference

#### Get all items

```http
  GET /
```


#### Get latest announcements

```http
  GET /latest
```

| Parameter    | Type      | Description                                             |
| :----------- | :-------- | :------------------------------------------------------ |
| `department` | `string`  | **Required**. name of department                        |
| `id`         | `integer` | **Required**. the id of the last announcement you have  |

#### latest(department, id)

it returns a list of the latest announcements for the department you are looking for

#### Get announcements count

```http
  GET /count
```

| Parameter    | Type      | Description         |
| :----------- | :-------- | :------------------ |
| `department` | `string`  | name of department  |

#### latest(department, id)

it returns a return the number of the announcements you have in the database

#### Get announcements by department

```http
  GET /{department}
```

| Parameter    | Type      | Description                       |
| :----------- | :-------- | :-------------------------------- |
| `department` | `string`  | **Required**. name of department  |

#### latest(department, id)

it returns all the announcements for the selected department

## Deployment

To deploy this project first of all you have to get a server to run the whole application

install postgresql and pg admin
``` 
sudo apt install postgresql postgresql-contrib
sudo apt install pgadmin4
```

run and connect to postgres

```
sudo -u postgres psql
```

then enter
```
\password
```
and enter your password

then quit with 
```
\q
```

Open pg admin
Register new server
Create a new database
Create a table with name deddhe

with everthing set up create a service for the api.
first copy the fastapi.service to the dir /etc/systemd/system

then edit WorkingDirectory, User, Group accordingly

and execute the commands
```
sudo systemctl daemon-reload
sudo systemctl start fastapi.service
sudo systemctl enable fastapi.service
sudo systemctl status fastapi.service
```

afterwards set up a cron with the python webScapping script and you are ready to go.

