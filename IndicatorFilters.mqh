#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
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
//| IndicatorFilters.mqh - Combined indicator filters                |
//+------------------------------------------------------------------+

// Input parameters - Breakout
input int      BreakoutType = 0;           // 0=Range, 1=BollingerBands, 2=ATR
input bool     AllowLong = true;           // Allow long positions
input bool     AllowShort = true;          // Allow short positions
input bool     RequireVolumeConfirm = true;// Require volume confirmation
input bool     RequireRetest = false;      // Wait for retest before entry
input ENUM_TIMEFRAMES RangeTF = PERIOD_D1; // Timeframe for range calculation
input int      TrendFilterEMA = 200;       // EMA period for trend filter (0=disabled)
input ENUM_TIMEFRAMES ExecTF = PERIOD_M15; // Timeframe for trade execution

// Input parameters - News filter
input bool     UseNewsFilter = true;       // Enable economic news filter
input int      NewsMinutesBefore = 60;     // Minutes before news to suspend trading
input int      NewsMinutesAfter = 30;      // Minutes after news to resume trading
input int      NewsImpactLevel = 3;        // Minimum impact level: 1=low, 2=medium, 3=high
input bool     CloseOnHighImpact = true;   // Close positions before high impact news

// Input parameters - Indicator filters
input bool     UseATRFilter = true;        // Enable ATR filter
input int      ATRPeriod = 14;             // ATR period
input double   MinATRPips = 20;            // Minimum required ATR (pips)
input double   MaxATRPips = 150;           // Maximum allowed ATR (pips)
input double   ATR_Mult_Min = 1.25;        // Minimum ATR multiplier for breakout validation
input double   ATR_Mult_Max = 3.0;         // Maximum ATR multiplier

input bool     UseBBFilter = true;         // Enable Bollinger Bands filter
input int      BBPeriod = 20;              // Bollinger Bands period
input double   BBDeviation = 2.0;          // Bollinger Bands standard deviation
input double   Min_Width_Pips = 30;        // Minimum BB width (pips)
input double   Max_Width_Pips = 120;       // Maximum BB width (pips)

input bool     UseEMAFilter = true;        // Enable EMA filter
input int      EMAPeriod = 200;            // EMA period for trend filter
input ENUM_TIMEFRAMES EMATf = PERIOD_H1;   // EMA timeframe

input bool     UseADXFilter = true;        // Enable ADX filter
input int      ADXPeriod = 14;             // ADX period
input double   ADXThreshold = 20.0;        // Minimum ADX threshold

input bool     UseRSIFilter = false;       // Enable RSI filter
input int      RSIPeriod = 14;             // RSI period
input double   RSIOverbought = 70;         // RSI overbought level (don't buy above)
input double   RSIOversold = 30;           // RSI oversold level (don't sell below)

input bool     UseVolumeFilter = true;     // Enable volume filter
input int      VolumePeriod = 20;          // Volume average period
input double   VolumeMultiplier = 1.5;     // Minimum volume multiplier
input int      Vol_Confirm_Type = 1;       // 0=Tick, 1=Real

// Input parameters - Position management
input int      MagicNumber = 123456;       // Unique order identifier
input string   OrderComment = "RangeBreakEA"; // Order comment
input int      MaxSlippage = 3;            // Maximum allowed slippage (points)

// Global variables
int atrHandle = INVALID_HANDLE;
int bbHandle = INVALID_HANDLE;
int emaHandle = INVALID_HANDLE;
int adxHandle = INVALID_HANDLE;
int rsiHandle = INVALID_HANDLE;
int maVolumeHandle = INVALID_HANDLE;

//+------------------------------------------------------------------+
//| Initialization function                                          |
//+------------------------------------------------------------------+
bool InitFilters()
{
   // Initialize ATR handle
   if(UseATRFilter)
   {
      atrHandle = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
      if(atrHandle == INVALID_HANDLE)
      {
         Print("Failed to create ATR handle");
         return false;
      }
   }
   
   // Initialize Bollinger Bands handle
   if(UseBBFilter)
   {
      bbHandle = iBands(_Symbol, PERIOD_CURRENT, BBPeriod, 0, BBDeviation, PRICE_CLOSE);
      if(bbHandle == INVALID_HANDLE)
      {
         Print("Failed to create Bollinger Bands handle");
         return false;
      }
   }
   
   // Initialize EMA handle
   if(UseEMAFilter && EMAPeriod > 0)
   {
      emaHandle = iMA(_Symbol, EMATf, EMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
      if(emaHandle == INVALID_HANDLE)
      {
         Print("Failed to create EMA handle");
         return false;
      }
   }
   
   // Initialize ADX handle
   if(UseADXFilter)
   {
      adxHandle = iADX(_Symbol, PERIOD_CURRENT, ADXPeriod);
      if(adxHandle == INVALID_HANDLE)
      {
         Print("Failed to create ADX handle");
         return false;
      }
   }
   
   // Initialize RSI handle
   if(UseRSIFilter)
   {
      rsiHandle = iRSI(_Symbol, PERIOD_CURRENT, RSIPeriod, PRICE_CLOSE);
      if(rsiHandle == INVALID_HANDLE)
      {
         Print("Failed to create RSI handle");
         return false;
      }
   }
   
   // Initialize volume handle
   if(UseVolumeFilter)
   {
      maVolumeHandle = iMA(_Symbol, PERIOD_CURRENT, VolumePeriod, 0, MODE_SMA, (Vol_Confirm_Type == 0) ? VOLUME_TICK : VOLUME_REAL);
      if(maVolumeHandle == INVALID_HANDLE)
      {
         Print("Failed to create volume MA handle");
         return false;
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Deinitialization function                                        |
//+------------------------------------------------------------------+
void DeinitFilters()
{
   if(atrHandle != INVALID_HANDLE)
   {
      IndicatorRelease(atrHandle);
      atrHandle = INVALID_HANDLE;
   }
   
   if(bbHandle != INVALID_HANDLE)
   {
      IndicatorRelease(bbHandle);
      bbHandle = INVALID_HANDLE;
   }
   
   if(emaHandle != INVALID_HANDLE)
   {
      IndicatorRelease(emaHandle);
      emaHandle = INVALID_HANDLE;
   }
   
   if(adxHandle != INVALID_HANDLE)
   {
      IndicatorRelease(adxHandle);
      adxHandle = INVALID_HANDLE;
   }
   
   if(rsiHandle != INVALID_HANDLE)
   {
      IndicatorRelease(rsiHandle);
      rsiHandle = INVALID_HANDLE;
   }
   
   if(maVolumeHandle != INVALID_HANDLE)
   {
      IndicatorRelease(maVolumeHandle);
      maVolumeHandle = INVALID_HANDLE;
   }
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
bool IsRetestLong(double level, double RetestTolerancePips = 5)
{
   double point   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol     = RetestTolerancePips * point * 10;
   double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (lowBar <= level + tol && closeBar > level);
}

bool IsRetestShort(double level, double RetestTolerancePips = 5)
{
   double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double tol      = RetestTolerancePips * point * 10;
   double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   return (highBar >= level - tol && closeBar < level);
}

//+------------------------------------------------------------------+
//| Get indicator value helper                                       |
//+------------------------------------------------------------------+
double GetIndicatorValue(int handle, int buffer, int shift)
{
   double value[1];
   if(CopyBuffer(handle, buffer, shift, 1, value) <= 0)
      return 0.0;
   return value[0];
}

//+------------------------------------------------------------------+
//| Trend entry (MA crossover)                                       |
//+------------------------------------------------------------------+
bool IsTrendLong(int fastHandle, int slowHandle, int SignalShift = 0)
{
   double fast0 = GetIndicatorValue(fastHandle, 0, SignalShift);
   double slow0 = GetIndicatorValue(slowHandle, 0, SignalShift);
   double fast1 = GetIndicatorValue(fastHandle, 0, SignalShift + 1);
   double slow1 = GetIndicatorValue(slowHandle, 0, SignalShift + 1);
   return (fast1 <= slow1 && fast0 > slow0);
}

bool IsTrendShort(int fastHandle, int slowHandle, int SignalShift = 0)
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
   if(!UseATRFilter) return true;
   
   double atrValue = GetIndicatorValue(atrHandle, 0, 0);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double atrPips = atrValue / point;
   
   // Check ATR range
   if(atrPips < MinATRPips || atrPips > MaxATRPips)
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Bollinger Bands Filter                                           |
//+------------------------------------------------------------------+
bool CheckBBFilter()
{
   if(!UseBBFilter) return true;
   
   double upperBand = GetIndicatorValue(bbHandle, 1, 0);
   double lowerBand = GetIndicatorValue(bbHandle, 2, 0);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   double widthPips = (upperBand - lowerBand) / point;
   
   // Check BB width range
   if(widthPips < Min_Width_Pips || widthPips > Max_Width_Pips)
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| EMA Filter                                                       |
//+------------------------------------------------------------------+
bool CheckEMAFilter(bool forLong)
{
   if(!UseEMAFilter || EMAPeriod <= 0) return true;
   
   double emaValue = GetIndicatorValue(emaHandle, 0, 0);
   double currentPrice = iClose(_Symbol, EMATf, 0);
   
   if(forLong)
      return currentPrice > emaValue;
   else
      return currentPrice < emaValue;
}

//+------------------------------------------------------------------+
//| ADX Filter                                                       |
//+------------------------------------------------------------------+
bool CheckADXFilter()
{
   if(!UseADXFilter) return true;
   
   double adxValue = GetIndicatorValue(adxHandle, 0, 0);
   
   return adxValue >= ADXThreshold;
}

//+------------------------------------------------------------------+
//| RSI Filter                                                       |
//+------------------------------------------------------------------+
bool CheckRSIFilter(bool forLong)
{
   if(!UseRSIFilter) return true;
   
   double rsiValue = GetIndicatorValue(rsiHandle, 0, 0);
   
   if(forLong)
      return rsiValue < RSIOverbought && rsiValue > RSIOversold;
   else
      return rsiValue < RSIOverbought && rsiValue > RSIOversold;
}

//+------------------------------------------------------------------+
//| Volume Filter                                                    |
//+------------------------------------------------------------------+
bool CheckVolumeFilter()
{
   if(!UseVolumeFilter || !RequireVolumeConfirm) return true;
   
   double currentVolume = (Vol_Confirm_Type == 0) ? 
                         iVolume(_Symbol, PERIOD_CURRENT, 0) : 
                         iRealVolume(_Symbol, PERIOD_CURRENT, 0);
   
   double avgVolume = GetIndicatorValue(maVolumeHandle, 0, 0);
   
   if(avgVolume <= 0) return true;
   
   return currentVolume >= avgVolume * VolumeMultiplier;
}

//+------------------------------------------------------------------+
//| News Filter                                                      |
//+------------------------------------------------------------------+
bool CheckNewsFilter()
{
   if(!UseNewsFilter) return true;
   
   // This is a placeholder for actual news checking logic
   // In a real implementation, you would connect to a news API or service
   // For now, we'll return true to allow trading
   
   // Placeholder logic:
   // 1. Get current time
   // 2. Check if there are any high impact news events within NewsMinutesBefore/After
   // 3. If CloseOnHighImpact is true and high impact news is coming, close positions
   // 4. Return false if trading should be suspended
   
   return true;
}

//+------------------------------------------------------------------+
//| Combined Filter Check                                            |
//+------------------------------------------------------------------+
bool CheckAllFilters(bool forLong)
{
   // Check news filter first
   if(!CheckNewsFilter())
      return false;
   
   // Check ATR filter
   if(!CheckATRFilter())
      return false;
   
   // Check Bollinger Bands filter
   if(!CheckBBFilter())
      return false;
   
   // Check EMA filter
   if(!CheckEMAFilter(forLong))
      return false;
   
   // Check ADX filter
   if(!CheckADXFilter())
      return false;
   
   // Check RSI filter
   if(!CheckRSIFilter(forLong))
      return false;
   
   // Check volume filter
   if(!CheckVolumeFilter())
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Calculate lot size                                               |
//+------------------------------------------------------------------+
double CalcLotSize(double riskPercent = 1.0, double stopLossPips = 50)
{
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   if(tickSize <= 0 || tickValue <= 0 || lotStep <= 0)
      return 0.01;
   
   double riskAmount = accountBalance * riskPercent / 100.0;
   double stopLossPoints = stopLossPips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double moneyPerLot = stopLossPoints / tickSize * tickValue;
   
   if(moneyPerLot <= 0)
      return 0.01;
   
   double lots = riskAmount / moneyPerLot;
   
   // Normalize to lot step
   lots = MathFloor(lots / lotStep) * lotStep;
   
   // Apply min/max lot constraints
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   lots = MathMax(lots, minLot);
   lots = MathMin(lots, maxLot);
   
   return lots;
}

//+------------------------------------------------------------------+
//| Get breakout level based on type                                 |
//+------------------------------------------------------------------+
double GetBreakoutLevel(int type, bool forLong)
{
   switch(type)
   {
      case 0: // Range
      {
         double high = iHigh(_Symbol, RangeTF, 1);
         double low = iLow(_Symbol, RangeTF, 1);
         return forLong ? high : low;
      }
      
      case 1: // Bollinger Bands
      {
         double upperBand = GetIndicatorValue(bbHandle, 1, 1);
         double lowerBand = GetIndicatorValue(bbHandle, 2, 1);
         return forLong ? upperBand : lowerBand;
      }
      
      case 2: // ATR
      {
         double atrValue = GetIndicatorValue(atrHandle, 0, 1);
         double closePrice = iClose(_Symbol, PERIOD_CURRENT, 1);
         return forLong ? closePrice + atrValue * ATR_Mult_Min : 
                          closePrice - atrValue * ATR_Mult_Min;
      }
   }
   
   return 0.0;
}

//+------------------------------------------------------------------+
//| Main entry signal check                                          |
//+------------------------------------------------------------------+
bool CheckEntrySignal(bool forLong)
{
   // Check if direction is allowed
   if(forLong && !AllowLong) return false;
   if(!forLong && !AllowShort) return false;
   
   // Check if we're on the execution timeframe
   if(!IsNewBar(ExecTF))
      return false;
   
   // Get breakout level
   double breakoutLevel = GetBreakoutLevel(BreakoutType, forLong);
   
   if(breakoutLevel <= 0)
      return false;
   
   // Check breakout
   bool isBreakout = forLong ? IsBreakoutLong(breakoutLevel) : IsBreakoutShort(breakoutLevel);
   
   if(!isBreakout)
      return false;
   
   // Check retest if required
   if(RequireRetest)
   {
      bool isRetest = forLong ? IsRetestLong(breakoutLevel) : IsRetestShort(breakoutLevel);
      if(!isRetest)
         return false;
   }
   
   // Check all filters
   if(!CheckAllFilters(forLong))
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
