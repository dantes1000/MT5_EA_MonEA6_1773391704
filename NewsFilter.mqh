//+------------------------------------------------------------------+
//|                                                      NewsFilter.mqh |
//|                        Economic News Filtering with FFCal Indicator |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property strict
input int BreakoutType = 0; // 0=Range, 1=BollingerBands, 2=ATR
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
input double ADXThreshold = 20.0; // Seuil ADX minimum
input bool UseRSIFilter = false; // Activer le filtre RSI
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
//| Input Parameters                                                 |
//+------------------------------------------------------------------+
input bool   AllowLong = true;                     // Allow long positions
input bool   AllowShort = true;                    // Allow short positions
input bool   RequireVolumeConfirm = true;          // Require volume confirmation
input bool   RequireRetest = false;                // Wait for retest before entry
input ENUM_TIMEFRAMES RangeTF = PERIOD_D1;         // Timeframe for range calculation
input int    TrendFilterEMA = 200;                 // EMA period for trend filter (0=disabled)
input ENUM_TIMEFRAMES ExecTF = PERIOD_M15;         // Timeframe for trade execution
input bool   UseNewsFilter = true;                 // Enable economic news filter
input int    NewsMinutesBefore = 60;               // Minutes before news to suspend trading
input int    NewsMinutesAfter = 30;                // Minutes after news to resume trading
input int    NewsImpactLevel = 3;                  // Minimum impact level: 1=low, 2=medium, 3=high
input bool   CloseOnHighImpact = true;             // Close positions before high-impact news
input double ATRMin = 0.5;                         // Minimum ATR filter
input double ATRMax = 2.0;                         // Maximum ATR filter
input double BBWidthMin = 0.5;                     // Minimum Bollinger Bands width
input double BBWidthMax = 2.0;                     // Maximum Bollinger Bands width
input int    ADXPeriod = 14;                       // ADX period
input double ADXMin = 20.0;                        // Minimum ADX value
input int    RSIPeriod = 14;                       // RSI period
input double RSIOverbought = 70.0;                 // Overbought level
input double RSIOversold = 30.0;                   // Oversold level
input int    VolumeSMA = 20;                       // Volume SMA period
input double VolumeThreshold = 1.5;                // Volume threshold multiplier
input int    TradingStartHour = 8;                 // Trading start hour (GMT)
input int    TradingEndHour = 21;                  // Trading end hour (GMT)
input bool   CloseBeforeWeekend = true;            // Close positions before weekend
input double RetestTolerancePips = 5.0;            // Retest tolerance in pips
input int    SignalShift = 0;                      // Signal shift

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
int atrHandle, bbHandle, emaHandle, adxHandle, rsiHandle, volumeHandle;
double point;

//+------------------------------------------------------------------+
//| Initialization Function                                          |
//+------------------------------------------------------------------+
void InitIndicators()
{
   point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   atrHandle = iATR(_Symbol, PERIOD_CURRENT, 14);
   bbHandle = iBands(_Symbol, PERIOD_CURRENT, 20, 0, 2.0, PRICE_CLOSE);
   if(TrendFilterEMA > 0) emaHandle = iMA(_Symbol, PERIOD_H1, TrendFilterEMA, 0, MODE_EMA, PRICE_CLOSE);
   adxHandle = iADX(_Symbol, PERIOD_CURRENT, ADXPeriod);
   rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, RSIPeriod, PRICE_CLOSE);
   volumeHandle = iMA(_Symbol, PERIOD_CURRENT, VolumeSMA, 0, MODE_SMA, VOLUME_TICK);
}

//+------------------------------------------------------------------+
//| Indicator Value Getter                                           |
//+------------------------------------------------------------------+
double GetIndicatorValue(int handle, int buffer, int shift)
{
   double value[];
   ArraySetAsSeries(value, true);
   CopyBuffer(handle, buffer, shift, 1, value);
   return value[0];
}

//+------------------------------------------------------------------+
//| New Bar Detection                                                |
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
//| Breakout Entry Functions                                         |
//+------------------------------------------------------------------+
bool IsBreakoutLong(double level, double tolerancePips = 0)
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   return ask > level + tolerancePips * point * 10;
}

bool IsBreakoutShort(double level, double tolerancePips = 0)
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   return bid < level - tolerancePips * point * 10;
}

//+------------------------------------------------------------------+
//| Retest Check After Breakout                                      |
//+------------------------------------------------------------------+
bool IsRetestLong(double level)
{
   double tol = RetestTolerancePips * point * 10;
   double lowBar = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level)
{
   double tol = RetestTolerancePips * point * 10;
   double highBar = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

//+------------------------------------------------------------------+
//| Trend Entry (MA Crossover)                                       |
//+------------------------------------------------------------------+
bool IsTrendLong(int fastHandle, int slowHandle)
{
   double fast0 = GetIndicatorValue(fastHandle, 0, SignalShift);
   double slow0 = GetIndicatorValue(slowHandle, 0, SignalShift);
   double fast1 = GetIndicatorValue(fastHandle, 0, SignalShift + 1);
   double slow1 = GetIndicatorValue(slowHandle, 0, SignalShift + 1);
   return (fast1 <= slow1 && fast0 > slow0);
}

bool IsTrendShort(int fastHandle, int slowHandle)
{
   double fast0 = GetIndicatorValue(fastHandle, 0, SignalShift);
   double slow0 = GetIndicatorValue(slowHandle, 0, SignalShift);
   double fast1 = GetIndicatorValue(fastHandle, 0, SignalShift + 1);
   double slow1 = GetIndicatorValue(slowHandle, 0, SignalShift + 1);
   return (fast1 >= slow1 && fast0 < slow0);
}

//+------------------------------------------------------------------+
//| ATR Filter                                                       |
//+------------------------------------------------------------------+
bool CheckATRFilter()
{
   double atr = GetIndicatorValue(atrHandle, 0, 0);
   return (atr >= ATRMin && atr <= ATRMax);
}

//+------------------------------------------------------------------+
//| Bollinger Bands Filter                                           |
//+------------------------------------------------------------------+
bool CheckBBFilter()
{
   double upper = GetIndicatorValue(bbHandle, 1, 0);
   double lower = GetIndicatorValue(bbHandle, 2, 0);
   double width = (upper - lower) / iClose(_Symbol, PERIOD_CURRENT, 0);
   return (width >= BBWidthMin && width <= BBWidthMax);
}

//+------------------------------------------------------------------+
//| EMA Trend Filter                                                 |
//+------------------------------------------------------------------+
bool CheckEMAFilter()
{
   if(TrendFilterEMA == 0) return true;
   double price = iClose(_Symbol, PERIOD_H1, 0);
   double ema = GetIndicatorValue(emaHandle, 0, 0);
   return (price > ema && AllowLong) || (price < ema && AllowShort);
}

//+------------------------------------------------------------------+
//| ADX Filter                                                       |
//+------------------------------------------------------------------+
bool CheckADXFilter()
{
   double adx = GetIndicatorValue(adxHandle, 0, 0);
   return adx >= ADXMin;
}

//+------------------------------------------------------------------+
//| RSI Filter                                                       |
//+------------------------------------------------------------------+
bool CheckRSIFilter()
{
   double rsi = GetIndicatorValue(rsiHandle, 0, 0);
   return (rsi < RSIOverbought && rsi > RSIOversold);
}

//+------------------------------------------------------------------+
//| Volume Filter                                                    |
//+------------------------------------------------------------------+
bool CheckVolumeFilter()
{
   if(!RequireVolumeConfirm) return true;
   double volume = iVolume(_Symbol, PERIOD_CURRENT, 0);
   double volumeSMA = GetIndicatorValue(volumeHandle, 0, 0);
   return volume > volumeSMA * VolumeThreshold;
}

//+------------------------------------------------------------------+
//| Time Filters                                                     |
//+------------------------------------------------------------------+
bool CheckTradingTime()
{
   MqlDateTime timeStruct;
   TimeGMT(timeStruct);
   int hour = timeStruct.hour;
   int dayOfWeek = timeStruct.day_of_week;
   
   // Check trading session
   if(hour < TradingStartHour || hour >= TradingEndHour) return false;
   
   // Check weekend
   if(CloseBeforeWeekend && dayOfWeek == 5 && hour >= 21) return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| News Filter (FFCal Integration)                                  |
//+------------------------------------------------------------------+
bool CheckNewsFilter()
{
   if(!UseNewsFilter) return true;
   
   MqlDateTime currentTime;
   TimeGMT(currentTime);
   datetime now = StructToTime(currentTime);
   
   // Simulated FFCal data structure
   struct NewsEvent
   {
      datetime time;
      int impact;
      string currency;
   };
   
   // Example news events (in real implementation, fetch from FFCal)
   NewsEvent events[] = {
      {D'2023.10.01 14:30', 3, "USD"},
      {D'2023.10.01 16:00', 2, "EUR"}
   };
   
   for(int i = 0; i < ArraySize(events); i++)
   {
      if(events[i].currency != _Symbol) continue;
      
      datetime eventTime = events[i].time;
      int impact = events[i].impact;
      
      if(impact >= NewsImpactLevel)
      {
         datetime startSuspend = eventTime - NewsMinutesBefore * 60;
         datetime endSuspend = eventTime + NewsMinutesAfter * 60;
         
         if(now >= startSuspend && now <= endSuspend)
         {
            return false;
         }
         
         if(CloseOnHighImpact && impact == 3 && now >= startSuspend - 300 && now < startSuspend)
         {
            // Trigger position closure logic
            return false;
         }
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Main Filter Function                                             |
//+------------------------------------------------------------------+
bool IsTradingAllowed()
{
   // Check time filters
   if(!CheckTradingTime()) return false;
   
   // Check news filter
   if(!CheckNewsFilter()) return false;
   
   // Check indicator filters
   if(!CheckATRFilter()) return false;
   if(!CheckBBFilter()) return false;
   if(!CheckEMAFilter()) return false;
   if(!CheckADXFilter()) return false;
   if(!CheckRSIFilter()) return false;
   if(!CheckVolumeFilter()) return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Position Management                                              |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionGetSymbol(i) == _Symbol)
      {
         trade.PositionClose(PositionGetTicket(i));
      }
   }
}

//+------------------------------------------------------------------+
//| Entry Signal Generation                                          |
//+------------------------------------------------------------------+
bool GenerateLongSignal()
{
   if(!AllowLong) return false;
   
   // Calculate range high
   double rangeHigh = iHigh(_Symbol, RangeTF, 0);
   
   // Check breakout
   if(IsBreakoutLong(rangeHigh))
   {
      if(RequireRetest)
      {
         return IsRetestLong(rangeHigh);
      }
      return true;
   }
   
   return false;
}

bool GenerateShortSignal()
{
   if(!AllowShort) return false;
   
   // Calculate range low
   double rangeLow = iLow(_Symbol, RangeTF, 0);
   
   // Check breakout
   if(IsBreakoutShort(rangeLow))
   {
      if(RequireRetest)
      {
         return IsRetestShort(rangeLow);
      }
      return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Main Execution Function                                          |
//+------------------------------------------------------------------+
void OnTick()
{
   // Initialize indicators on first run
   static bool initialized = false;
   if(!initialized)
   {
      InitIndicators();
      initialized = true;
   }
   
   // Check for new bar on execution timeframe
   if(IsNewBar(ExecTF))
   {
      // Check if trading is allowed
      if(IsTradingAllowed())
      {
         // Generate signals
         bool longSignal = GenerateLongSignal();
         bool shortSignal = GenerateShortSignal();
         
         // Execute trades based on signals
         if(longSignal)
         {
            // Place long order logic here
         }
         
         if(shortSignal)
         {
            // Place short order logic here
         }
      }
      else
      {
         // Close positions if required
         if(CloseOnHighImpact)
         {
            CloseAllPositions();
         }
      }
   }
}

//+------------------------------------------------------------------+