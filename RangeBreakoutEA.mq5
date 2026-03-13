#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int VolumePeriod = 20; // Période moyenne de volume
input double VolumeMultiplier = 1.5; // Multiplicateur volume minimum
input int Vol_Confirm_Type = 1; // 0=Tick, 1=Réel
input string OrderComment = "RangeBreakEA"; // Commentaire sur les ordres
input int MaxSlippage = 3; // Slippage maximum autorisé (points)
input int MaxOrderRetries = 3; // Tentatives max d'envoi d'ordre
input bool UsePartialClose = false; // Activer la fermeture partielle
input double PartialCloseRR = 1.0; // R:R auquel fermer partiellement
input int PartialClosePct = 50; // Pourcentage à fermer partiellement (%)
input bool AllowAddPosition = false; // Autoriser ajout de position si en profit
input double AddPositionRR = 1.0; // R:R minimum pour ajouter une position
input int LotMethod = 0; // 0=% capital (Equity), 1=lot fixe, 2=lot par pip
input double FixedLot = 0.01; // Lot fixe (si LotMethod=1)
input double MinLot = 0.01; // Lot minimum
input double MaxLot = 5.0; // Lot maximum
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

#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Indicators/Trend.mqh>
#include <Arrays/ArrayObj.mqh>

// Input parameters - Breakout
input int BreakoutType = 0;               // 0=Range, 1=BollingerBands, 2=ATR
input bool AllowLong = true;              // Allow long positions
input bool AllowShort = true;             // Allow short positions
input bool RequireVolumeConfirm = true;   // Require volume confirmation
input bool RequireRetest = false;         // Wait for retest before entry
input ENUM_TIMEFRAMES RangeTF = PERIOD_D1; // Timeframe for range calculation
input int TrendFilterEMA = 200;           // EMA period for trend filter (0=disabled)
input ENUM_TIMEFRAMES ExecTF = PERIOD_M15; // Timeframe for trade execution

// Input parameters - News filter
input bool UseNewsFilter = true;          // Enable economic news filter
input int NewsMinutesBefore = 60;         // Minutes before news to suspend trading
input int NewsMinutesAfter = 30;          // Minutes after news to resume trading
input int NewsImpactLevel = 3;            // Minimum impact level: 1=low, 2=medium, 3=high
input bool CloseOnHighImpact = true;      // Close positions before high impact news

// Input parameters - Indicator filters
input bool UseATRFilter = true;           // Enable ATR filter
input int ATRPeriod = 14;                 // ATR period
input double MinATRPips = 20;             // Minimum ATR required (pips)
input double MaxATRPips = 150;            // Maximum ATR allowed (pips)
input double ATR_Mult_Min = 1.25;         // Minimum ATR multiplier for breakout
input double ATR_Mult_Max = 3.0;          // Maximum ATR multiplier
input bool UseBBFilter = true;            // Enable Bollinger Bands filter
input int BBPeriod = 20;                  // Bollinger Bands period
input double BBDeviation = 2.0;           // BB standard deviation
input double Min_Width_Pips = 30;         // Minimum BB width (pips)
input double Max_Width_Pips = 120;        // Maximum BB width (pips)
input bool UseEMAFilter = true;           // Enable EMA filter
input int EMAPeriod = 200;                // EMA period for trend filter
input ENUM_TIMEFRAMES EMATf = PERIOD_H1;  // EMA timeframe
input bool UseADXFilter = true;           // Enable ADX filter
input int ADXPeriod = 14;                 // ADX period
input double ADXThreshold = 20.0;         // Minimum ADX threshold
input bool UseRSIFilter = false;          // Enable RSI filter
input int RSIPeriod = 14;                 // RSI period
input double RSIOverbought = 70;          // RSI overbought level
input double RSIOversold = 30;            // RSI oversold level
input bool UseVolumeFilter = true;        // Enable volume filter
input int VolumeSMAPeriod = 20;           // Volume SMA period
input double VolumeThreshold = 1.5;       // Volume threshold multiplier

// Input parameters - Trading
input double LotSize = 0.01;              // Fixed lot size (0 for auto)
input double RiskPercent = 1.0;           // Risk percentage for auto lot
input int StopLossPips = 50;              // Stop loss in pips
input int TakeProfitPips = 100;           // Take profit in pips
input int MagicNumber = 12345;            // Expert advisor magic number
input int Slippage = 3;                   // Maximum slippage in points

// Global variables
CTrade Trade;
CSymbolInfo SymbolInfo;
double Point;
int ATRHandle, BBHandle, EMAHandle, ADXHandle, RSIHandle;
double RangeHigh, RangeLow;
datetime LastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Initialize symbol info
   if(!SymbolInfo.Name(_Symbol))
      return INIT_FAILED;
   
   Point = SymbolInfo.Point();
   
   // Initialize indicator handles
   if(UseATRFilter)
      ATRHandle = iATR(_Symbol, PERIOD_CURRENT, ATRPeriod);
   
   if(UseBBFilter)
      BBHandle = iBands(_Symbol, PERIOD_CURRENT, BBPeriod, 0, BBDeviation, PRICE_CLOSE);
   
   if(UseEMAFilter && TrendFilterEMA > 0)
      EMAHandle = iMA(_Symbol, EMATf, EMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
   
   if(UseADXFilter)
      ADXHandle = iADX(_Symbol, PERIOD_CURRENT, ADXPeriod);
   
   if(UseRSIFilter)
      RSIHandle = iRSI(_Symbol, PERIOD_CURRENT, RSIPeriod, PRICE_CLOSE);
   
   Trade.SetExpertMagicNumber(MagicNumber);
   Trade.SetDeviationInPoints(Slippage);
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Release indicator handles
   if(ATRHandle != INVALID_HANDLE) IndicatorRelease(ATRHandle);
   if(BBHandle != INVALID_HANDLE) IndicatorRelease(BBHandle);
   if(EMAHandle != INVALID_HANDLE) IndicatorRelease(EMAHandle);
   if(ADXHandle != INVALID_HANDLE) IndicatorRelease(ADXHandle);
   if(RSIHandle != INVALID_HANDLE) IndicatorRelease(RSIHandle);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check for new bar on execution timeframe
   if(!IsNewBar(ExecTF))
      return;
   
   // Update symbol info
   SymbolInfo.RefreshRates();
   
   // Check news filter
   if(UseNewsFilter && IsNewsTime())
   {
      if(CloseOnHighImpact && NewsImpactLevel >= 3)
         CloseAllPositions();
      return;
   }
   
   // Calculate range levels
   CalculateRangeLevels();
   
   // Check for breakout signals
   CheckBreakoutSignals();
   
   // Manage existing positions
   ManagePositions();
}

//+------------------------------------------------------------------+
//| New bar detection                                                |
//+------------------------------------------------------------------+
bool IsNewBar(ENUM_TIMEFRAMES tf)
{
   datetime currentBar = iTime(_Symbol, tf, 0);
   if(LastBarTime != currentBar)
   {
      LastBarTime = currentBar;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Calculate range levels                                           |
//+------------------------------------------------------------------+
void CalculateRangeLevels()
{
   if(BreakoutType == 0) // Range breakout
   {
      RangeHigh = iHigh(_Symbol, RangeTF, 1);
      RangeLow = iLow(_Symbol, RangeTF, 1);
   }
   else if(BreakoutType == 1) // Bollinger Bands breakout
   {
      double upper[], lower[];
      ArraySetAsSeries(upper, true);
      ArraySetAsSeries(lower, true);
      
      if(CopyBuffer(BBHandle, 1, 0, 2, upper) > 0 &&
         CopyBuffer(BBHandle, 2, 0, 2, lower) > 0)
      {
         RangeHigh = upper[1];
         RangeLow = lower[1];
      }
   }
   else if(BreakoutType == 2) // ATR breakout
   {
      double atr[];
      ArraySetAsSeries(atr, true);
      
      if(CopyBuffer(ATRHandle, 0, 0, 2, atr) > 0)
      {
         double currentHigh = iHigh(_Symbol, RangeTF, 1);
         double currentLow = iLow(_Symbol, RangeTF, 1);
         
         RangeHigh = currentHigh + atr[1] * ATR_Mult_Min;
         RangeLow = currentLow - atr[1] * ATR_Mult_Min;
      }
   }
}

//+------------------------------------------------------------------+
//| Check breakout signals                                           |
//+------------------------------------------------------------------+
void CheckBreakoutSignals()
{
   // Check if all filters pass
   if(!CheckAllFilters())
      return;
   
   // Check for long breakout
   if(AllowLong && IsBreakoutLong(RangeHigh))
   {
      if(!RequireRetest || IsRetestLong(RangeHigh))
      {
         if(CheckVolumeConfirmation())
            OpenPosition(ORDER_TYPE_BUY);
      }
   }
   
   // Check for short breakout
   if(AllowShort && IsBreakoutShort(RangeLow))
   {
      if(!RequireRetest || IsRetestShort(RangeLow))
      {
         if(CheckVolumeConfirmation())
            OpenPosition(ORDER_TYPE_SELL);
      }
   }
}

//+------------------------------------------------------------------+
//| Breakout entry check                                             |
//+------------------------------------------------------------------+
bool IsBreakoutLong(double level)
{
   double ask = SymbolInfo.Ask();
   return ask > level;
}

bool IsBreakoutShort(double level)
{
   double bid = SymbolInfo.Bid();
   return bid < level;
}

//+------------------------------------------------------------------+
//| Retest check after breakout                                      |
//+------------------------------------------------------------------+
bool IsRetestLong(double level)
{
   double lowBar = iLow(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   double tolerance = 10 * Point * 10; // 10 pips tolerance
   
   return (lowBar <= level + tolerance && closeBar > level);
}

bool IsRetestShort(double level)
{
   double highBar = iHigh(_Symbol, PERIOD_CURRENT, 1);
   double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
   double tolerance = 10 * Point * 10; // 10 pips tolerance
   
   return (highBar >= level - tolerance && closeBar < level);
}

//+------------------------------------------------------------------+
//| Check all indicator filters                                      |
//+------------------------------------------------------------------+
bool CheckAllFilters()
{
   // ATR filter
   if(UseATRFilter && !CheckATRFilter())
      return false;
   
   // Bollinger Bands filter
   if(UseBBFilter && !CheckBBFilter())
      return false;
   
   // EMA filter
   if(UseEMAFilter && !CheckEMAFilter())
      return false;
   
   // ADX filter
   if(UseADXFilter && !CheckADXFilter())
      return false;
   
   // RSI filter
   if(UseRSIFilter && !CheckRSIFilter())
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Check ATR filter                                                 |
//+------------------------------------------------------------------+
bool CheckATRFilter()
{
   double atr[];
   ArraySetAsSeries(atr, true);
   
   if(CopyBuffer(ATRHandle, 0, 0, 1, atr) <= 0)
      return false;
   
   double atrPips = atr[0] / (Point * 10);
   
   // Check ATR range
   if(atrPips < MinATRPips || atrPips > MaxATRPips)
      return false;
   
   // Check breakout distance vs ATR
   double breakoutDistance = MathAbs(RangeHigh - RangeLow);
   double atrValue = atr[0];
   
   if(breakoutDistance < atrValue * ATR_Mult_Min ||
      breakoutDistance > atrValue * ATR_Mult_Max)
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Bollinger Bands filter                                     |
//+------------------------------------------------------------------+
bool CheckBBFilter()
{
   double upper[], lower[];
   ArraySetAsSeries(upper, true);
   ArraySetAsSeries(lower, true);
   
   if(CopyBuffer(BBHandle, 1, 0, 1, upper) <= 0 ||
      CopyBuffer(BBHandle, 2, 0, 1, lower) <= 0)
      return false;
   
   double widthPips = (upper[0] - lower[0]) / (Point * 10);
   
   return (widthPips >= Min_Width_Pips && widthPips <= Max_Width_Pips);
}

//+------------------------------------------------------------------+
//| Check EMA filter                                                 |
//+------------------------------------------------------------------+
bool CheckEMAFilter()
{
   double ema[];
   ArraySetAsSeries(ema, true);
   
   if(CopyBuffer(EMAHandle, 0, 0, 1, ema) <= 0)
      return false;
   
   double currentPrice = SymbolInfo.Ask();
   
   // For long: price must be above EMA
   // For short: price must be below EMA
   // We'll check this in the specific signal check
   return true;
}

//+------------------------------------------------------------------+
//| Check ADX filter                                                 |
//+------------------------------------------------------------------+
bool CheckADXFilter()
{
   double adx[];
   ArraySetAsSeries(adx, true);
   
   if(CopyBuffer(ADXHandle, 0, 0, 1, adx) <= 0)
      return false;
   
   return adx[0] >= ADXThreshold;
}

//+------------------------------------------------------------------+
//| Check RSI filter                                                 |
//+------------------------------------------------------------------+
bool CheckRSIFilter()
{
   double rsi[];
   ArraySetAsSeries(rsi, true);
   
   if(CopyBuffer(RSIHandle, 0, 0, 1, rsi) <= 0)
      return false;
   
   // Don't buy in overbought, don't sell in oversold
   // We'll check this in the specific signal check
   return true;
}

//+------------------------------------------------------------------+
//| Check volume confirmation                                        |
//+------------------------------------------------------------------+
bool CheckVolumeConfirmation()
{
   if(!RequireVolumeConfirm)
      return true;
   
   if(!UseVolumeFilter)
      return true;
   
   // Calculate volume SMA
   double volumeSMA = 0;
   for(int i = 1; i <= VolumeSMAPeriod; i++)
   {
      volumeSMA += iVolume(_Symbol, PERIOD_CURRENT, i);
   }
   volumeSMA /= VolumeSMAPeriod;
   
   double currentVolume = iVolume(_Symbol, PERIOD_CURRENT, 0);
   
   return currentVolume > volumeSMA * VolumeThreshold;
}

//+------------------------------------------------------------------+
//| Check if current time is near news                               |
//+------------------------------------------------------------------+
bool IsNewsTime()
{
   // Note: FFCal indicator integration would require custom implementation
   // This is a placeholder for the logic
   // In real implementation, you would query the FFCal indicator
   
   // For now, return false (no news)
   // To implement properly:
   // 1. Create FFCal indicator handle
   // 2. Check for high impact news within specified time window
   // 3. Return true if news is found
   
   return false;
}

//+------------------------------------------------------------------+
//| Open position                                                    |
//+------------------------------------------------------------------+
void OpenPosition(ENUM_ORDER_TYPE orderType)
{
   // Calculate lot size
   double lot = CalcLotSize();
   if(lot <= 0)
      return;
   
   // Calculate stop loss and take profit
   double sl = 0, tp = 0;
   
   if(orderType == ORDER_TYPE_BUY)
   {
      sl = SymbolInfo.Ask() - StopLossPips * Point * 10;
      tp = SymbolInfo.Ask() + TakeProfitPips * Point * 10;
      
      // Additional EMA filter check for long
      if(UseEMAFilter)
      {
         double ema[];
         ArraySetAsSeries(ema, true);
         if(CopyBuffer(EMAHandle, 0, 0, 1, ema) > 0)
         {
            if(SymbolInfo.Ask() <= ema[0])
               return;
         }
      }
      
      // RSI filter check for long
      if(UseRSIFilter)
      {
         double rsi[];
         ArraySetAsSeries(rsi, true);
         if(CopyBuffer(RSIHandle, 0, 0, 1, rsi) > 0)
         {
            if(rsi[0] >= RSIOverbought)
               return;
         }
      }
   }
   else if(orderType == ORDER_TYPE_SELL)
   {
      sl = SymbolInfo.Bid() + StopLossPips * Point * 10;
      tp = SymbolInfo.Bid() - TakeProfitPips * Point * 10;
      
      // Additional EMA filter check for short
      if(UseEMAFilter)
      {
         double ema[];
         ArraySetAsSeries(ema, true);
         if(CopyBuffer(EMAHandle, 0, 0, 1, ema) > 0)
         {
            if(SymbolInfo.Bid() >= ema[0])
               return;
         }
      }
      
      // RSI filter check for short
      if(UseRSIFilter)
      {
         double rsi[];
         ArraySetAsSeries(rsi, true);
         if(CopyBuffer(RSIHandle, 0, 0, 1, rsi) > 0)
         {
            if(rsi[0] <= RSIOversold)
               return;
         }
      }
   }
   
   // Open the position
   Trade.PositionOpen(_Symbol, orderType, lot, 
                      (orderType == ORDER_TYPE_BUY) ? SymbolInfo.Ask() : SymbolInfo.Bid(),
                      sl, tp, "Range Breakout EA");
}

//+------------------------------------------------------------------+
//| Calculate lot size                                               |
//+------------------------------------------------------------------+
double CalcLotSize()
{
   if(LotSize > 0)
      return LotSize;
   
   // Calculate based on risk percentage
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * RiskPercent / 100.0;
   
   double tickValue = SymbolInfo.TickValue();
   double stopLossPoints = StopLossPips * 10; // Convert pips to points
   
   if(tickValue > 0 && stopLossPoints > 0)
   {
      double lot = riskAmount / (stopLossPoints * tickValue);
      
      // Normalize lot size
      double minLot = SymbolInfo.LotsMin();
      double maxLot = SymbolInfo.LotsMax();
      double lotStep = SymbolInfo.LotsStep();
      
      lot = MathRound(lot / lotStep) * lotStep;
      lot = MathMax(minLot, MathMin(lot, maxLot));
      
      return lot;
   }
   
   return 0.01; // Default lot size
}

//+------------------------------------------------------------------+
//| Manage existing positions                                        |
//+------------------------------------------------------------------+
void ManagePositions()
{
   // Check if any positions need to be closed due to news
   if(UseNewsFilter && CloseOnHighImpact && NewsImpactLevel >= 3 && IsNewsTime())
   {
      CloseAllPositions();
   }
}

//+------------------------------------------------------------------+
//| Close all positions                                              |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            Trade.PositionClose(PositionGetTicket(i));
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Get indicator value                                              |
//+------------------------------------------------------------------+
double GetIndicatorValue(int handle, int buffer, int shift)
{
   double value[];
   ArraySetAsSeries(value, true);
   
   if(CopyBuffer(handle, buffer, shift, 1, value) > 0)
      return value[0];
   
   return 0;
}
