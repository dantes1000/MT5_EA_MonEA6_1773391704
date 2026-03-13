```markdown
# MonEA6 - Expert Advisor pour MetaTrader 5

## Description
MonEA6 est un Expert Advisor (EA) pour MetaTrader 5 implémentant une stratégie de **cassure de range (Breakout)** sur la session asiatique. L'EA identifie un range de prix établi pendant une période définie, place des ordres en attente aux niveaux clés, et exécute des trades uniquement lorsque la cassure est confirmée par plusieurs filtres techniques et de volume. La gestion des risques est stricte et conçue pour être compatible avec les exigences des prop firms.

**Stratégie clé :** Range Breakout Asian Session.
- **Range calculé sur :** Session asiatique (00:00 - 06:00 GMT), analysé sur le timeframe D1.
- **Exécution des trades :** Sur le timeframe M15 ou M30 après l'ouverture de Londres (après 08:00 GMT).
- **Confirmation requise :** Volume significatif et validation par ATR.
- **Filtres principaux :** Tendances H1 (EMA200), ADX, Bollinger Bands, et filtre d'actualités économiques.

## Prérequis
- **Plateforme :** MetaTrader 5 (Build 2000 ou supérieur recommandé).
- **Compte :** Compte de trading Forex (de préférence avec spreads serrés).
- **Broker :** Doit fournir les données de volume réel (`SYMBOL_TRADE_TICK_VALUE`) pour le filtre de volume.
- **Indicateur :** L'indicateur `FFCal` (Forex Factory Calendar) doit être installé dans le dossier `MQL5\Indicators\` pour le filtre d'actualités.

## Installation
1.  Téléchargez les fichiers de l'EA (`MonEA6.mq5` et les fichiers `.mqh` inclus).
2.  Ouvrez le dossier de données de MetaTrader 5 via `Fichier > Ouvrir le Dossier de Données` dans le terminal.
3.  Copiez le fichier `MonEA6.mq5` dans le sous-dossier `MQL5\Experts\`.
4.  Copiez tous les fichiers `.mqh` (fichiers d'en-tête) dans le sous-dossier `MQL5\Include\`.
5.  Assurez-vous que l'indicateur `FFCal.ex5` est présent dans `MQL5\Indicators\`.
6.  Redémarrez MetaTrader 5 ou actualisez la liste des Experts Advisors dans le `Navigateur` (clic droit > Rafraîchir).

## Paramètres Configurables

### 1. Paramètres du Breakout / Cassure
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `BreakoutType` | 0 | Type de cassure: `0`=Range, `1`=BollingerBands, `2`=ATR. |
| `AllowLong` | true | Autoriser les positions d'achat (Long). |
| `AllowShort` | true | Autoriser les positions de vente (Short). |
| `RequireVolumeConfirm` | true | Exiger une confirmation par le volume pour valider la cassure. |
| `RequireRetest` | false | Attendre un retest du niveau cassé avant d'entrer (désactivé). |
| `RangeTF` | PERIOD_D1 | Timeframe pour le calcul du range (D1). |
| `TrendFilterEMA` | 200 | Période de l'EMA utilisé comme filtre de tendance globale. Mettre `0` pour désactiver. |
| `ExecTF` | PERIOD_M15 | Timeframe pour l'exécution des ordres et la surveillance. |

### 2. Filtre d'Actualités Économiques (News)
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `UseNewsFilter` | true | Activer/désactiver le filtre d'actualités. |
| `NewsMinutesBefore` | 60 | Suspendre le trading X minutes avant une annonce. |
| `NewsMinutesAfter` | 30 | Suspendre le trading X minutes après une annonce. |
| `NewsImpactLevel` | 3 | Niveau d'impact minimum à filtrer: `1`=Faible, `2`=Moyen, `3`=Fort. |
| `CloseOnHighImpact` | true | Fermer automatiquement les positions avant une news d'impact Fort. |

### 3. Filtres Indicateurs
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `UseATRFilter` | true | Activer le filtre de volatilité ATR. |
| `ATRPeriod` | 14 | Période de calcul de l'ATR. |
| `MinATRPips` / `MaxATRPips` | 20 / 150 | Volatilité ATR minimum/maximum autorisée (en pips). |
| `ATR_Mult_Min` / `ATR_Mult_Max` | 1.25 / 3.0 | Multiplicateur ATR min/max pour valider l'amplitude de la cassure. |
| `UseBBFilter` | true | Activer le filtre de largeur de range (Bollinger Bands). |
| `Min_Width_Pips` / `Max_Width_Pips` | 30 / 120 | Largeur BB minimum/maximum autorisée pour le range (pips). |
| `UseEMAFilter` | true | Activer le filtre de tendance EMA. |
| `EMATf` | PERIOD_H1 | Timeframe de l'EMA de tendance (H1). |
| `UseADXFilter` | true | Activer le filtre de force de tendance ADX. |
| `ADXThreshold` | 20.0 | Seuil ADX minimum pour considérer une tendance. |
| `UseRSIFilter` | false | Activer le filtre RSI de surachat/survente. |
| `UseVolumeFilter` | true | Activer le filtre de confirmation par volume. |
| `VolumeMultiplier` | 1.5 | Le volume courant doit dépasser la SMA(Volume,20) de ce multiplicateur. |

### 4. Gestion des Positions et des Risques
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `MagicNumber` | 123456 | Identifiant unique pour les ordres de cet EA. |
| `LotMethod` | 0 | Méthode de calcul des lots: `0`=% du capital, `1`=Lot fixe, `2`=Lot par pip. |
| `RiskPercent` | 1.0 | Pourcentage du capital (Equity) risqué par trade (si LotMethod=0). |
| `StopLossPips` | 0 | Stop Loss fixe en pips. `0` = Stop Loss placé à l'opposé du range. |
| `TakeProfitPips` | 0 | Take Profit fixe en pips. `0` = TP dynamique basé sur ATR ou R:R. |
| `RiskRewardRatio` | 1.5 | Ratio Risque/Récompense cible minimum. |
| `MaxDailyDDPercent` | 5.0 | Drawdown quotidien maximum autorisé (en %). |
| `MaxOpenTrades` | 1 | Nombre maximum de positions ouvertes simultanément. |
| `MaxTradesPerDay` | 3 | Nombre maximum de trades ouverts par jour. |
| `UseTrailingStop` | true | Activer le trailing stop dynamique. |
| `Trail_Method` | 1 | Méthode de trailing: `0`=Fixe (pips), `1`=Basé sur ATR. |
| `Trail_Activation_PC` | 50 | Pourcentage de profit atteint pour activer le trailing stop. |

### 5. Paramètres du Range de Prix
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `RangePeriodHours` | 6 | Durée de la fenêtre pour calculer le range (ex: 6h pour la session Asiatique). |
| `MarginPips` | 5 | Marge de sécurité ajoutée au-delà des High/Low du range pour placer les ordres en attente. |
| `MinRangePips` / `MaxRangePips` | 20 / 120 | Amplitude minimum/maximum du range pour générer un signal (pips). |

### 6. Filtres Temporels
| Paramètre | Valeur par défaut | Description |
| :--- | :--- | :--- |
| `TradeStartHour` / `TradeEndHour` | 8 / 23 | Heure de début/fin de la fenêtre de trading quotidienne (GMT). |
| `TradeMonday` ... `TradeFriday` | true | Jours de la semaine où le trading est autorisé. |
| `WeekendClose` | true | Fermer toutes les positions avant le week-end. |
| `FridayCloseHour` | 21 | Heure de fermeture des positions le vendredi (GMT). |

## Utilisation
1.  **Graphique :** Attachez l'EA `MonEA6` sur un graphique H1, M30 ou M15 d'une paire majeure (ex: EURUSD).
2.  **Timeframe d'exécution :** L'EA utilise principalement le timeframe défini dans `ExecTF` (M15 par défaut) pour surveiller les prix et exécuter les trades. Le range est analysé sur D1.
3.  **Période de trading :** L'EA est actif pendant la fenêtre horaire définie (par défaut, 08:00 - 23:00 GMT). Les ordres en attente (Buy Stop/Sell Stop) sont placés juste après l'ouverture de Londres.
4.  **Monitoring :** Surveillez les commentaires dans le coin supérieur gauche du graphique pour l'état de l'EA (Range calculé, ordres placés, filtres actifs, etc.).
5.  **Journal (Logs) :** Consultez l'onglet `Experts` du Terminal pour les logs détaillés, les erreurs et les confirmations d'exécution des ordres.

## Avertissement sur les Risques
**LE TRADING SUR MARCHÉS FINANCIERS IMPLIQUE DES RISQUES ÉLEVÉS DE PERTE.** Cet Expert Advisor est un outil logiciel fourni "TEL QUEL", à des fins éducatives ou de recherche. Son passé ne préjuge en rien de ses résultats futurs.

- **Testez rigoureusement** l'EA en backtest et sur un compte de démonstration avant toute utilisation en conditions réelles.
- **Comprenez parfaitement** la stratégie et tous les paramètres avant de les modifier.
- **Ajustez la taille de vos lots** (`RiskPercent`) en fonction de votre capital et de votre tolérance au risque. La valeur par défaut de 1% peut être trop élevée pour certains.
- **L'EA inclut un filtre d'actualités**, mais aucune garantie n'est donnée quant à son efficacité pour protéger des volatilités extrêmes.
- **Le développeur/éditeur décline toute responsabilité** concernant les pertes financières ou les dommages résultant de l'utilisation de ce logiciel.
- **Il est de votre responsabilité** de surveiller le fonctionnement de l'EA et d'intervenir si nécessaire.
```