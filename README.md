# CartulaireMSM
Application web pour la présentation d'un échantillon d'actes du cartulaire de l'abbaye du Mont Saint-Michel

---

Installation

Dans le terminal (Linux ou macOS)

  * Cloner le dossier : ```git clone https://github.com/ArsGeo/CartulaireMSM```
  
  * Installer l'environnement virtuel :
  
    * Vérifier que la version de Python est bien 3.x : ```python --version```;
    
    * Aller dans le dossier : ```cd Cartulaire```;
    
    * Installer l'environnement : ```python3 -m venv [nom de l'environnement]```.
  
  * Installer les packages et librairies :
  
    * Activer l'environnement : ```source [nom de l'environnement]/bin/activate```;
    
    * Flask et lxml : ```pip3 install flask==1.1.2``` et ```pip3 install lxml==4.5.1``` ;
    
    * SQLAlchemy : ```pip install flask_sqlalchemy==2.5.1``` ;
    
    * Vérifier que tout est installé : ```pip freeze``` ;
    
    * Sortir de l'environnement : ```deactivate``` ;

---

Lancement
  
  * Activer l'environnement : ```source [nom de l'environnement]/bin/activate``` ;
    
  * Lancement : ```python run.py``` ;
    
  * Aller sur ```http://127.0.0.1:5000/``` ;
    
  * Désactivation : ```ctrl + c``` ;
    
  * Sortir de l'environnement : ```deactivate```.
