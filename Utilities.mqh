//+------------------------------------------------------------------+
//|                                                      Utilities.mqh |
//|                        Helper functions for MQL5                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
input int BreakoutType = 0; // 0=Range, 1=BollingerBands, 2=ATR
input bool AllowLong = true; // Autoriser les positions long
input bool AllowShort = true; // Autoriser les positions short
input bool RequireVolumeConfirm = true; // Exiger confirmation du volume
input bool RequireRetest = false; // Attendre un retest avant entrée
input PERIOD RangeTF = PERIOD_D1; // Timeframe pour le calcul du range
input int TrendFilterEMA = 200; // Période EMA pour filtre de tendance (0=désactivé)
input PERIOD ExecTF = PERIOD_M15; // Timeframe pour l'exécution des trades (M15 ou M30)
input bool UseNewsFilter = true; // Activer le filtre d'actualités économiques
input int NewsMinutesBefore = 60; // Minutes avant la news pour suspendre le trading
input int NewsMinutesAfter = 30; // Minutes après la news pour reprendre le trading
input int NewsImpactLevel = 3; // Niveau d'impact minimum : 1=faible, 2=moyen, 3=fort
input bool CloseOnHighImpact = true; // Fermer les positions avant news à fort impact
input bool UseATRFilter = true; // Activer le filtre ATR
input int ATRPeriod = 14; // Période ATR
input int MinATRPips = 20; // ATR minimum requis (pips)
input int MaxATRPips = 150; // ATR maximum autorisé (pips)
input double ATR_Mult_Min = 1.25; // Multiplicateur ATR minimum pour valider un breakout
input double ATR_Mult_Max = 3.0; // Multiplicateur ATR maximum
input bool UseBBFilter = true; // Activer le filtre Bollinger Bands
input int BBPeriod = 20; // Période Bollinger Bands
input double BBDeviation = 2.0; // Déviation standard BB
input int Min_Width_Pips = 30; // Largeur BB minimum (pips)
input int Max_Width_Pips = 120; // Largeur BB maximum (pips)
input bool UseEMAFilter = true; // Activer le filtre EMA
input int EMAPeriod = 200; // Période EMA pour filtre de tendance
input PERIOD EMATf = PERIOD_H1; // Timeframe EMA
input bool UseADXFilter = true; // Activer le filtre ADX
input int ADXPeriod = 14; // Période ADX
input double ADXThreshold = 20.0; // Seuil ADX minimum
input bool UseRSIFilter = false; // Activer le filtre RSI
input int RSIPeriod = 14; // Période RSI
input int RSIOverbought = 70; // Niveau surachat RSI (ne pas acheter au-dessus)
input int RSIOversold = 30; // Niveau survente RSI (ne pas vendre en dessous)
input bool UseVolumeFilter = true; // Activer le filtre de volume
input int VolumePeriod = 20; // Période moyenne de volume
input double VolumeMultiplier = 1.5; // Multiplicateur volume minimum
input int Vol_Confirm_Type = 1; // 0=Tick, 1=Réel
input int MagicNumber = 123456; // Identifiant unique des ordres de l'EA
input string OrderComment = "RangeBreakEA"; // Commentaire sur les ordres
input int MaxSlippage = 3; // Slippage maximum autorisé (points)
input int MaxOrderRetries = 3; // Tentatives max d'envoi d'ordre
input bool UsePartialClose = false; // Activer la fermeture partielle
input double PartialCloseRR = 1.0; // R:R auquel fermer partiellement
input int PartialClosePct = 50; // Pourcentage à fermer partiellement (%)
input bool AllowAddPosition = false; // Autoriser ajout de position si en profit
input double AddPositionRR = 1.0; // R:R minimum pour ajouter une position
input int LotMethod = 0; // 0=% capital (Equity), 1=lot fixe, 2=lot par pip
input double RiskPercent = 1.0; // % du capital risqué par trade (0.5-1%)
input double FixedLot = 0.01; // Lot fixe (si LotMethod=1)
input double MinLot = 0.01; // Lot minimum
input double MaxLot = 5.0; // Lot maximum
input int StopLossPips = 0; // Stop Loss en pips (0=basé sur l'opposé du range)
input int TakeProfitPips = 0; // Take Profit en pips (0=dynamique ou R:R)
input double RiskRewardRatio = 1.5; // Ratio R:R minimum (si TP_Method=Fixed_RR)
input double MaxDailyDDPercent = 5.0; // Drawdown quotidien maximum (%)
input double MaxTotalDDPercent = 15.0; // Drawdown total maximum (%)
input int MaxOpenTrades = 1; // Nombre maximum de positions simultanées
input int MaxTradesPerDay = 3; // Nombre maximum de trades par jour
input int MinTimeBetweenTrades = 1; // Délai minimum entre trades (heures)
input int RangePeriodHours = 6; // Durée du range en heures (minuit-6h GMT)
input int MarginPips = 5; // Marge au-delà du High/Low avant entrée (pips)
input int MinRangePips = 20; // Range minimum pour valider le signal (pips)
input int MaxRangePips = 120; // Range maximum autorisé (pips)
input int Range_Calc = 0; // 0=Closed_Candles (bougies closes)
input int TradeStartHour = 8; // Heure de début du trading (GMT, ouverture London)
input int TradeEndHour = 23; // Heure de fin du trading (GMT)
input bool TradeMonday = true; // Autoriser le trading le lundi
input bool TradeTuesday = true; // Autoriser le trading le mardi
input bool TradeWednesday = true; // Autoriser le trading le mercredi
input bool TradeThursday = true; // Autoriser le trading le jeudi
input bool TradeFriday = true; // Autoriser le trading le vendredi
input bool WeekendClose = true; // Fermer toutes les positions avant le weekend
input int FridayCloseHour = 21; // Heure de fermeture le vendredi (GMT)
input bool CloseOutsideHours = false; // Fermer les positions hors fenêtre de trading
input int FastEMAPeriod = 20; // Période EMA rapide
input int SlowEMAPeriod = 50; // Période EMA lente
input int TrendEMAPeriod = 200; // Période EMA de tendance globale
input bool UseSuperTrend = false; // Activer SuperTrend comme filtre/trailing
input int SuperTrendPeriod = 10; // Période SuperTrend
input double SuperTrendMultiplier = 3.0; // Multiplicateur ATR SuperTrend
input PERIOD HTFTimeframe = PERIOD_H1; // Timeframe HTF pour la direction
input bool UseTrailingStop = true; // Activer le trailing stop
input int TrailingStopPips = 0; // Distance trailing stop (pips, 0=ATR-based)
input int TrailingStepPips = 0; // Pas du trailing stop (pips, 0=ATR-based)
input int Trail_Method = 1; // 0=Fixe, 1=ATR
input double Trail_Mult = 0.5; // Multiplicateur ATR pour le trailing
input int Trail_Activation_PC = 50; // Pourcentage de profit pour activer le trailing (50%)

//+------------------------------------------------------------------+
//| Timeframe conversion functions                                   |
//+------------------------------------------------------------------+
enum ENUM_TIMEFRAMES_CUSTOM
{
   PERIOD_M1 = 1,
   PERIOD_M5 = 5,
   PERIOD_M15 = 15,
   PERIOD_M30 = 30,
   PERIOD_H1 = 60,
   PERIOD_H4 = 240,
   PERIOD_D1 = 1440,
   PERIOD_W1 = 10080,
   PERIOD_MN1 = 43200
};

// Convert timeframe string to ENUM_TIMEFRAMES
ENUM_TIMEFRAMES StringToTimeframe(string tfStr)
{
   if(tfStr == "M1") return PERIOD_M1;
   if(tfStr == "M5") return PERIOD_M5;
   if(tfStr == "M15") return PERIOD_M15;
   if(tfStr == "M30") return PERIOD_M30;
   if(tfStr == "H1") return PERIOD_H1;
   if(tfStr == "H4") return PERIOD_H4;
   if(tfStr == "D1") return PERIOD_D1;
   if(tfStr == "W1") return PERIOD_W1;
   if(tfStr == "MN1") return PERIOD_MN1;
   return PERIOD_CURRENT;
}

// Convert ENUM_TIMEFRAMES to minutes
int TimeframeToMinutes(ENUM_TIMEFRAMES tf)
{
   switch(tf)
   {
      case PERIOD_M1: return 1;
      case PERIOD_M5: return 5;
      case PERIOD_M15: return 15;
      case PERIOD_M30: return 30;
      case PERIOD_H1: return 60;
      case PERIOD_H4: return 240;
      case PERIOD_D1: return 1440;
      case PERIOD_W1: return 10080;
      case PERIOD_MN1: return 43200;
      default: return 0;
   }
}

// Check if timeframe1 is higher than timeframe2
bool IsHigherTimeframe(ENUM_TIMEFRAMES tf1, ENUM_TIMEFRAMES tf2)
{
   return TimeframeToMinutes(tf1) > TimeframeToMinutes(tf2);
}

//+------------------------------------------------------------------+
//| Pip calculation functions                                        |
//+------------------------------------------------------------------+
// Get point value for current symbol
double GetPointValue()
{
   return SymbolInfoDouble(_Symbol, SYMBOL_POINT);
}

// Get pip value for current symbol (handles 3,4,5 digit brokers)
double GetPipValue()
{
   double point = GetPointValue();
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   
   if(digits == 3 || digits == 5) // JPY pairs and some others
      return point * 10;
   else // Standard 4 digit pairs
      return point * 10;
}

// Convert pips to price
double PipsToPrice(double pips)
{
   return pips * GetPipValue();
}

// Convert price to pips
double PriceToPips(double price)
{
   double pipValue = GetPipValue();
   if(pipValue > 0)
      return price / pipValue;
   return 0;
}

// Calculate distance in pips between two prices
double PriceDistanceInPips(double price1, double price2)
{
   return MathAbs(price1 - price2) / GetPipValue();
}

//+------------------------------------------------------------------+
//| Common validation functions                                      |
//+------------------------------------------------------------------+
// Check if symbol is valid for trading
bool IsValidSymbol(string symbol = "")
{
   if(symbol == "") symbol = _Symbol;
   
   if(!SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE))
      return false;
   
   if(SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED)
      return false;
   
   return true;
}

// Check if market is open for trading
bool IsMarketOpen(string symbol = "")
{
   if(symbol == "") symbol = _Symbol;
   
   // Check if symbol is valid
   if(!IsValidSymbol(symbol))
      return false;
   
   // Check if trading is allowed
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
      return false;
   
   // Check if expert advisor is allowed
   if(!MQLInfoInteger(MQL_TRADE_ALLOWED))
      return false;
   
   // Check if DDE is enabled
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
      return false;
   
   return true;
}

// Check if enough bars are available
bool HasEnoughBars(ENUM_TIMEFRAMES tf, int requiredBars)
{
   int bars = Bars(_Symbol, tf);
   return bars >= requiredBars;
}

// Validate price for order placement
bool IsValidPrice(double price)
{
   if(price <= 0)
      return false;
   
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize > 0)
   {
      // Check if price is a multiple of tick size
      double remainder = MathMod(price, tickSize);
      if(remainder > 0.00000001) // Small epsilon for floating point comparison
         return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| New bar detection                                                |
//+------------------------------------------------------------------+
bool IsNewBar(ENUM_TIMEFRAMES tf)
{
   static datetime lastBarTime = 0;
   datetime currentBar = iTime(_Symbol, tf, 0);
   if(lastBarTime != currentBar)
   {
      lastBarTime = currentBar;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Breakout entry functions                                         |
//+------------------------------------------------------------------+
bool IsBreakoutLong(double level, double tolerancePips = 0)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double ask   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   return ask > level + tolerancePips * point * 10;
}

bool IsBreakoutShort(double level, double tolerancePips = 0)
{
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double bid   = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return bid < level - tolerancePips * point * 10;
}

//+------------------------------------------------------------------+
//| Retest check after breakout                                      |
//+------------------------------------------------------------------+
bool IsRetestLong(double level, double retestTolerancePips)
{
   double point   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol     = retestTolerancePips * point * 10;
   double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level, double retestTolerancePips)
{
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol      = retestTolerancePips * point * 10;
   double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

//+------------------------------------------------------------------+
//| Trend entry functions                                            |
//+------------------------------------------------------------------+
bool IsTrendLong(int fastHandle, int slowHandle, int signalShift = 0)
{
   double fast0 = 0, slow0 = 0, fast1 = 0, slow1 = 0;
   
   // Get indicator values
   double fastBuffer[];
   double slowBuffer[];
   
   if(CopyBuffer(fastHandle, 0, signalShift, 2, fastBuffer) == 2 &&
      CopyBuffer(slowHandle, 0, signalShift, 2, slowBuffer) == 2)
   {
      fast0 = fastBuffer[0];
      slow0 = slowBuffer[0];
      fast1 = fastBuffer[1];
      slow1 = slowBuffer[1];
   }
   
   return (fast1 <= slow1 && fast0 > slow0);
}

bool IsTrendShort(int fastHandle, int slowHandle, int signalShift = 0)
{
   double fast0 = 0, slow0 = 0, fast1 = 0, slow1 = 0;
   
   // Get indicator values
   double fastBuffer[];
   double slowBuffer[];
   
   if(CopyBuffer(fastHandle, 0, signalShift, 2, fastBuffer) == 2 &&
      CopyBuffer(slowHandle, 0, signalShift, 2, slowBuffer) == 2)
   {
      fast0 = fastBuffer[0];
      slow0 = slowBuffer[0];
      fast1 = fastBuffer[1];
      slow1 = slowBuffer[1];
   }
   
   return (fast1 >= slow1 && fast0 < slow0);
}

//+------------------------------------------------------------------+
//| Volume validation functions                                      |
//+------------------------------------------------------------------+
// Check if volume is above SMA of volume
double GetVolumeSMA(int period = 20, int shift = 0)
{
   double volumeBuffer[];
   double sma = 0;
   
   if(CopyBuffer(iVolumes(_Symbol, PERIOD_CURRENT, VOLUME_TICK), 0, shift, period, volumeBuffer) == period)
   {
      for(int i = 0; i < period; i++)
         sma += volumeBuffer[i];
      sma /= period;
   }
   
   return sma;
}

bool IsVolumeAboveSMA(double multiplier = 1.5, int period = 20)
{
   double currentVolume = iVolume(_Symbol, PERIOD_CURRENT, 0);
   double volumeSMA = GetVolumeSMA(period, 0);
   
   if(volumeSMA > 0)
      return currentVolume > volumeSMA * multiplier;
   
   return false;
}

//+------------------------------------------------------------------+
//| Position size calculation                                        |
//+------------------------------------------------------------------+
// Calculate lot size based on risk percentage and stop loss
double CalcLotSize(double riskPercent, double stopLossPips, string symbol = "")
{
   if(symbol == "") symbol = _Symbol;
   
   // Get account balance
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   if(balance <= 0) return 0;
   
   // Calculate risk amount
   double riskAmount = balance * riskPercent / 100.0;
   
   // Get tick value
   double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   
   // Get point value
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   
   // Calculate lot size
   double lotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
   double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
   
   if(stopLossPips <= 0 || tickValue <= 0 || point <= 0)
      return minLot;
   
   double stopLossPrice = stopLossPips * GetPipValue();
   double lotSize = riskAmount / (stopLossPrice * tickValue / point);
   
   // Normalize lot size
   lotSize = MathRound(lotSize / lotStep) * lotStep;
   lotSize = MathMax(lotSize, minLot);
   lotSize = MathMin(lotSize, maxLot);
   
   return lotSize;
}

//+------------------------------------------------------------------+
//| Indicator value helper                                           |
//+------------------------------------------------------------------+
double GetIndicatorValue(int handle, int bufferNum, int shift)
{
   double buffer[];
   double value = 0;
   
   if(CopyBuffer(handle, bufferNum, shift, 1, buffer) == 1)
      value = buffer[0];
   
   return value;
}

//+------------------------------------------------------------------+
//| News filter helper functions                                     |
//+------------------------------------------------------------------+
// Note: FFCal indicator integration would require external indicator
// This is a placeholder structure for news filtering logic
struct NewsEvent
{
   datetime time;
   string   currency;
   string   event;
   int      impact; // 1=low, 2=medium, 3=high
};

// Check if trading should be suspended due to news
bool ShouldSuspendTrading(datetime currentTime, int minutesBefore = 60, int minutesAfter = 30, int minImpact = 3)
{
   // This function would integrate with FFCal indicator
   // For now, returns false as placeholder
   return false;
}

//+------------------------------------------------------------------+
//| ATR filter functions                                             |
//+------------------------------------------------------------------+
// Get ATR value in pips
double GetATRInPips(int period = 14, int shift = 0)
{
   int atrHandle = iATR(_Symbol, PERIOD_CURRENT, period);
   double atrValue = GetIndicatorValue(atrHandle, 0, shift);
   
   if(atrHandle != INVALID_HANDLE)
      IndicatorRelease(atrHandle);
   
   return PriceToPips(atrValue);
}

// Check if ATR is within valid range
bool IsATRValid(double minPips = 20, double maxPips = 150, int period = 14)
{
   double atrPips = GetATRInPips(period, 0);
   return (atrPips >= minPips && atrPips <= maxPips);
}

// Check if breakout exceeds ATR multiplier
bool IsBreakoutBeyondATR(double breakoutLevel, double currentPrice, double multiplier = 1.25, int period = 14)
{
   double atrValue = GetATRInPips(period, 0);
   double distancePips = PriceDistanceInPips(breakoutLevel, currentPrice);
   
   return distancePips >= atrValue * multiplier;
}

//+------------------------------------------------------------------+
//| Bollinger Bands filter functions                                 |
//+------------------------------------------------------------------+
// Get Bollinger Bands width in pips
double GetBBWidthInPips(int period = 20, double deviation = 2.0, int shift = 0)
{
   int bbHandle = iBands(_Symbol, PERIOD_CURRENT, period, 0, deviation, PRICE_CLOSE);
   
   double upperBand = GetIndicatorValue(bbHandle, 1, shift);
   double lowerBand = GetIndicatorValue(bbHandle, 2, shift);
   
   if(bbHandle != INVALID_HANDLE)
      IndicatorRelease(bbHandle);
   
   return PriceDistanceInPips(upperBand, lowerBand);
}

// Check if BB width is valid
bool IsBBWidthValid(double minWidthPips = 30, int period = 20, double deviation = 2.0)
{
   double widthPips = GetBBWidthInPips(period, deviation, 0);
   return widthPips >= minWidthPips;
}

//+------------------------------------------------------------------+
//| EMA trend filter functions                                       |
//+------------------------------------------------------------------+
// Check if price is above EMA for long trades
bool IsPriceAboveEMA(int emaPeriod, ENUM_TIMEFRAMES tf = PERIOD_H1)
{
   int emaHandle = iMA(_Symbol, tf, emaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   double emaValue = GetIndicatorValue(emaHandle, 0, 0);
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   if(emaHandle != INVALID_HANDLE)
      IndicatorRelease(emaHandle);
   
   return currentPrice > emaValue;
}

// Check if price is below EMA for short trades
bool IsPriceBelowEMA(int emaPeriod, ENUM_TIMEFRAMES tf = PERIOD_H1)
{
   int emaHandle = iMA(_Symbol, tf, emaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   double emaValue = GetIndicatorValue(emaHandle, 0, 0);
   double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   if(emaHandle != INVALID_HANDLE)
      IndicatorRelease(emaHandle);
   
   return currentPrice < emaValue;
}

//+------------------------------------------------------------------+
//| ADX trend strength functions                                     |
//+------------------------------------------------------------------+
// Get ADX value
double GetADXValue(int period = 14, int shift = 0)
{
   int adxHandle = iADX(_Symbol, PERIOD_CURRENT, period);
   double adxValue = GetIndicatorValue(adxHandle, 0, shift); // Main ADX line
   
   if(adxHandle != INVALID_HANDLE)
      IndicatorRelease(adxHandle);
   
   return adxValue;
}

// Check if trend is strong enough
bool IsTrendStrong(double minStrength = 20, int period = 14)
{
   double adxValue = GetADXValue(period, 0);
   return adxValue >= minStrength;
}

//+------------------------------------------------------------------+
//| RSI overbought/oversold functions                                |
//+------------------------------------------------------------------+
// Get RSI value
double GetRSIValue(int period = 14, int shift = 0)
{
   int rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, period, PRICE_CLOSE);
   double rsiValue = GetIndicatorValue(rsiHandle, 0, shift);
   
   if(rsiHandle != INVALID_HANDLE)
      IndicatorRelease(rsiHandle);
   
   return rsiValue;
}

// Check if RSI is in overbought zone
bool IsRSIOverbought(double overboughtLevel = 70, int period = 14)
{
   double rsiValue = GetRSIValue(period, 0);
   return rsiValue >= overboughtLevel;
}

// Check if RSI is in oversold zone
bool IsRSIOversold(double oversoldLevel = 30, int period = 14)
{
   double rsiValue = GetRSIValue(period, 0);
   return rsiValue <= oversoldLevel;
}

//+------------------------------------------------------------------+
//| Range calculation functions                                      |
//+------------------------------------------------------------------+
// Get daily range high and low
bool GetDailyRange(double &high, double &low, int daysBack = 1)
{
   high = iHigh(_Symbol, PERIOD_D1, daysBack);
   low = iLow(_Symbol, PERIOD_D1, daysBack);
   
   return (high > 0 && low > 0);
}

// Get range for specified timeframe
bool GetRange(ENUM_TIMEFRAMES tf, double &high, double &low, int barsBack = 1)
{
   high = iHigh(_Symbol, tf, barsBack);
   low = iLow(_Symbol, tf, barsBack);
   
   return (high > 0 && low > 0);
}

//+------------------------------------------------------------------+
