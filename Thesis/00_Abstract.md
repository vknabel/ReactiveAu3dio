# Konzeption eines generischen Datenmodells für iOS im Kontext akustischer Lokalisation

## Abstract

1. Wieso in einem Satz? Wieso akustische Lokalisation?
2. Ziel: Konzeption
3. Vorgehen: grobes Inhaltsverzeichnis

**Wieso?**
Im Rahmen dieser Arbeit wird ein generisches Datenmodell für Anwendungen, in denen Entitäten anhand akustischer Signale lokalisiert werden müssen, entwickelt und implementiert.

Das erarbeitete Konzept beruht auf **(nicht-)funktionalen** Anforderungen, welche sich durch eine Analyse von drei fiktiven Anwendungen ergeben.

Zuerst werden diese vorgestellt und voneinander abgegrenzt. Anschließend wird die Spezifikation erarbeitet, die an ein System und an das Datenmodell gestellt werden, um alle vorgestellten Anwendungsfälle passend abbilden zu können.
Im Anschluss wird das Datenmodell als mögliche Lösung vorgestellt und anhand einer Implementierung **zentrale Elemente** beleuchtet.

Abschließend wird das gefundene generische Datenmodell mit einem problemspezifischen verglichen.

## Alte Texte

Ziel ist die Konzeption eines Datenmodells für mobile Endanwendungen unter iOS in denen bestimmte Elemente anhand akustischer Signale gefunden werden müssen. Denkbar wären beispielsweise Welten, die einige Szenarien enthalten, die nach Abschluss des Szenarios die Lösung nach gegebenen Kriterien beziehungsweise Zielen bewertet werden. Genauso sehr soll allerdings auch eine Anwendung unterstützt werden, die eine Geschichte durch das direkte aneinanderreihen einzelner Levels mit zusätzlichen Gesprächen zwischen fiktiven Charakteren erzählen will.
Die einzelnen Szenarien innerhalb des Konzepts mit den Welten sind hierbei stark hierarchisch angeordnet, während in dem zweiten Beispiel alle Szenarien seriell angeordnet sind. Weiter werden Szenarien gelöst, in dem man die gegebenen Ziele seriell abarbeitet, während beim ersten Beispiel am Anfang des Szenarios alle Ziele bekannt sind. Zusätzlich gibt es hier zusätzliche Ziele, die optional sind, aber die Wertung erhöhen, die es wiederum innerhalb einer Geschichte nicht gibt.

### Erweiterbarkeit

Das Datenmodell muss unabhängig von der expliziten Anwendungslogik erweiterbar und anpassbar sein. Beispielsweise müssen einfach neue Attribute zu Entitäten hinzugefügt werden wie Bewegungen, Animationen oder Soundeffekte. Anschließend muss es möglich sein die vorherigen Algorithmen durch neue zu ersetzen oder zu ergänzen, sodass die zusätzlichen Attribute entsprechend verarbeitet werden können.
