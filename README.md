# Application Web Java Servlet

## Description
Cette application web est construite en utilisant des **servlets Java** et nécessite **Apache Tomcat 10.1.15**, **Java 19.0.2**, et une base de données **PostgreSQL** pour fonctionner correctement.

## Prérequis

Avant de lancer l'application, assurez-vous que les éléments suivants sont installés et configurés sur votre machine :

- **Apache Tomcat 10.1.15**  
  Téléchargez et installez [Apache Tomcat 10.1.15](https://tomcat.apache.org/download-10.cgi).
  
- **Java 19.0.2**  
  Vous pouvez télécharger la dernière version de Java depuis [Oracle JDK](https://www.oracle.com/java/technologies/javase/jdk19-archive-downloads.html) ou utiliser un gestionnaire de version comme [SDKMAN!](https://sdkman.io/) pour l'installer.

- **PostgreSQL**  
  Téléchargez et installez [PostgreSQL](https://www.postgresql.org/download/). Assurez-vous que le serveur PostgreSQL est en cours d'exécution.

## Configuration

### 1. **Configurer la base de données PostgreSQL**
   
   - Créez une base de données PostgreSQL pour l'application ticketing.
   - Assurez-vous d'avoir les informations de connexion suivantes :
     - **URL de la base de données** : `jdbc:postgresql://<hôte>:<port>/<nom_de_la_base>`
     - **Utilisateur** : `<nom_utilisateur>`
     - **Mot de passe** : `<mot_de_passe>`

   Exemple de configuration JDBC dans config.properties:
   ```properties
   db.url=jdbc:postgresql://localhost:5432/ma_base
   db.username=mon_utilisateur
   db.password=mon_mot_de_passe
