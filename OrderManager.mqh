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

// OrderManager.mqh - Manages pending orders with retries, slippage, magic number, and comments
// Version 1.0

class COrderManager
{
private:
    // Configuration
    int      m_magic;           // Magic number for orders
    double   m_slippage;        // Slippage in points
    string   m_comment;         // Order comment
    int      m_max_retries;     // Maximum order placement retries
    int      m_retry_delay_ms;  // Delay between retries in milliseconds
    
    // State tracking
    bool     m_is_news_filter_active;  // News filter status
    datetime m_last_retry_time;        // Last retry timestamp
    
public:
    // Constructor
    COrderManager() : 
        m_magic(12345),
        m_slippage(10.0),
        m_comment("Breakout System"),
        m_max_retries(3),
        m_retry_delay_ms(1000),
        m_is_news_filter_active(false),
        m_last_retry_time(0)
    {
    }
    
    // Destructor
    ~COrderManager()
    {
    }
    
    // Set configuration
    void SetMagic(int magic) { m_magic = magic; }
    void SetSlippage(double slippage) { m_slippage = slippage; }
    void SetComment(string comment) { m_comment = comment; }
    void SetMaxRetries(int max_retries) { m_max_retries = max_retries; }
    void SetRetryDelay(int delay_ms) { m_retry_delay_ms = delay_ms; }
    
    // News filter control
    void SetNewsFilterActive(bool active) { m_is_news_filter_active = active; }
    bool IsNewsFilterActive() const { return m_is_news_filter_active; }
    
    // Calculate lot size (replaces SymbolInfo.Lots())
    double CalcLotSize(double risk_percent = 1.0, double stoploss_pips = 50.0)
    {
        double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double tick_value = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
        double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        
        if(account_balance <= 0 || tick_value <= 0 || tick_size <= 0 || point <= 0)
            return 0.01;
        
        // Calculate risk amount
        double risk_amount = account_balance * (risk_percent / 100.0);
        
        // Calculate lot size
        double stoploss_points = stoploss_pips * 10 * point;
        double lot_size = risk_amount / (stoploss_points / tick_size * tick_value);
        
        // Normalize to allowed lot steps
        double lot_step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
        double min_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
        double max_lot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
        
        lot_size = MathRound(lot_size / lot_step) * lot_step;
        lot_size = MathMax(min_lot, MathMin(max_lot, lot_size));
        
        return lot_size;
    }
    
    // Place buy stop order with retry logic
    bool PlaceBuyStop(double price, double lot_size, double stoploss, double takeprofit, int retry_count = 0)
    {
        // Check if news filter is active
        if(m_is_news_filter_active)
        {
            Print("News filter active - skipping order placement");
            return false;
        }
        
        // Check if we've exceeded max retries
        if(retry_count >= m_max_retries)
        {
            Print("Max retries (" + IntegerToString(m_max_retries) + ") exceeded for buy stop order");
            return false;
        }
        
        // Check if we need to wait before retry
        if(retry_count > 0)
        {
            datetime current_time = TimeCurrent();
            if(current_time - m_last_retry_time < m_retry_delay_ms / 1000)
            {
                Print("Waiting before retry...");
                return false;
            }
            m_last_retry_time = current_time;
        }
        
        // Prepare order request
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        
        request.action = TRADE_ACTION_PENDING;
        request.symbol = _Symbol;
        request.volume = lot_size;
        request.type = ORDER_TYPE_BUY_STOP;
        request.price = NormalizeDouble(price, _Digits);
        request.sl = (stoploss > 0) ? NormalizeDouble(stoploss, _Digits) : 0;
        request.tp = (takeprofit > 0) ? NormalizeDouble(takeprofit, _Digits) : 0;
        request.deviation = (int)m_slippage;
        request.magic = m_magic;
        request.comment = m_comment;
        request.type_filling = ORDER_FILLING_FOK;
        request.type_time = ORDER_TIME_DAY;
        
        // Send order
        bool success = OrderSend(request, result);
        
        if(success && result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Buy stop order placed successfully. Ticket: " + IntegerToString(result.order));
            return true;
        }
        else
        {
            Print("Failed to place buy stop order. Error: " + IntegerToString(result.retcode) + ", Retry: " + IntegerToString(retry_count + 1));
            
            // Retry if needed
            if(retry_count < m_max_retries - 1)
            {
                Print("Retrying in " + IntegerToString(m_retry_delay_ms) + "ms...");
                return PlaceBuyStop(price, lot_size, stoploss, takeprofit, retry_count + 1);
            }
        }
        
        return false;
    }
    
    // Place sell stop order with retry logic
    bool PlaceSellStop(double price, double lot_size, double stoploss, double takeprofit, int retry_count = 0)
    {
        // Check if news filter is active
        if(m_is_news_filter_active)
        {
            Print("News filter active - skipping order placement");
            return false;
        }
        
        // Check if we've exceeded max retries
        if(retry_count >= m_max_retries)
        {
            Print("Max retries (" + IntegerToString(m_max_retries) + ") exceeded for sell stop order");
            return false;
        }
        
        // Check if we need to wait before retry
        if(retry_count > 0)
        {
            datetime current_time = TimeCurrent();
            if(current_time - m_last_retry_time < m_retry_delay_ms / 1000)
            {
                Print("Waiting before retry...");
                return false;
            }
            m_last_retry_time = current_time;
        }
        
        // Prepare order request
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        
        request.action = TRADE_ACTION_PENDING;
        request.symbol = _Symbol;
        request.volume = lot_size;
        request.type = ORDER_TYPE_SELL_STOP;
        request.price = NormalizeDouble(price, _Digits);
        request.sl = (stoploss > 0) ? NormalizeDouble(stoploss, _Digits) : 0;
        request.tp = (takeprofit > 0) ? NormalizeDouble(takeprofit, _Digits) : 0;
        request.deviation = (int)m_slippage;
        request.magic = m_magic;
        request.comment = m_comment;
        request.type_filling = ORDER_FILLING_FOK;
        request.type_time = ORDER_TIME_DAY;
        
        // Send order
        bool success = OrderSend(request, result);
        
        if(success && result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Sell stop order placed successfully. Ticket: " + IntegerToString(result.order));
            return true;
        }
        else
        {
            Print("Failed to place sell stop order. Error: " + IntegerToString(result.retcode) + ", Retry: " + IntegerToString(retry_count + 1));
            
            // Retry if needed
            if(retry_count < m_max_retries - 1)
            {
                Print("Retrying in " + IntegerToString(m_retry_delay_ms) + "ms...");
                return PlaceSellStop(price, lot_size, stoploss, takeprofit, retry_count + 1);
            }
        }
        
        return false;
    }
    
    // Modify pending order
    bool ModifyOrder(ulong ticket, double new_price, double new_stoploss, double new_takeprofit)
    {
        // Check if news filter is active
        if(m_is_news_filter_active)
        {
            Print("News filter active - skipping order modification");
            return false;
        }
        
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        
        request.action = TRADE_ACTION_MODIFY;
        request.order = ticket;
        request.symbol = _Symbol;
        request.price = NormalizeDouble(new_price, _Digits);
        request.sl = (new_stoploss > 0) ? NormalizeDouble(new_stoploss, _Digits) : 0;
        request.tp = (new_takeprofit > 0) ? NormalizeDouble(new_takeprofit, _Digits) : 0;
        request.deviation = (int)m_slippage;
        
        bool success = OrderSend(request, result);
        
        if(success && result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Order " + IntegerToString(ticket) + " modified successfully");
            return true;
        }
        else
        {
            Print("Failed to modify order " + IntegerToString(ticket) + ". Error: " + IntegerToString(result.retcode));
            return false;
        }
    }
    
    // Delete pending order
    bool DeleteOrder(ulong ticket)
    {
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        
        request.action = TRADE_ACTION_REMOVE;
        request.order = ticket;
        request.symbol = _Symbol;
        
        bool success = OrderSend(request, result);
        
        if(success && result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Order " + IntegerToString(ticket) + " deleted successfully");
            return true;
        }
        else
        {
            Print("Failed to delete order " + IntegerToString(ticket) + ". Error: " + IntegerToString(result.retcode));
            return false;
        }
    }
    
    // Close position by ticket
    bool ClosePosition(ulong ticket)
    {
        if(!PositionSelectByTicket(ticket))
        {
            Print("Position " + IntegerToString(ticket) + " not found");
            return false;
        }
        
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        
        request.action = TRADE_ACTION_DEAL;
        request.position = ticket;
        request.symbol = _Symbol;
        request.volume = PositionGetDouble(POSITION_VOLUME);
        request.deviation = (int)m_slippage;
        request.magic = m_magic;
        request.comment = "Closed by news filter";
        
        // Determine direction
        if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
        {
            request.type = ORDER_TYPE_SELL;
            request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        }
        else
        {
            request.type = ORDER_TYPE_BUY;
            request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        }
        
        bool success = OrderSend(request, result);
        
        if(success && result.retcode == TRADE_RETCODE_DONE)
        {
            Print("Position " + IntegerToString(ticket) + " closed successfully");
            return true;
        }
        else
        {
            Print("Failed to close position " + IntegerToString(ticket) + ". Error: " + IntegerToString(result.retcode));
            return false;
        }
    }
    
    // Close all positions (for news filter)
    bool CloseAllPositions()
    {
        int total_positions = PositionsTotal();
        bool all_closed = true;
        
        for(int i = total_positions - 1; i >= 0; i--)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0)
            {
                if(!ClosePosition(ticket))
                {
                    all_closed = false;
                }
            }
        }
        
        return all_closed;
    }
    
    // Delete all pending orders (for news filter)
    bool DeleteAllPendingOrders()
    {
        int total_orders = OrdersTotal();
        bool all_deleted = true;
        
        for(int i = total_orders - 1; i >= 0; i--)
        {
            if(OrderGetTicket(i) > 0)
            {
                ulong ticket = OrderGetTicket(i);
                if(!DeleteOrder(ticket))
                {
                    all_deleted = false;
                }
            }
        }
        
        return all_deleted;
    }
    
    // Check if order exists with given magic number
    bool HasOrderWithMagic()
    {
        int total_orders = OrdersTotal();
        
        for(int i = 0; i < total_orders; i++)
        {
            if(OrderGetTicket(i) > 0)
            {
                if(OrderGetInteger(ORDER_MAGIC) == m_magic)
                {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    // Check if position exists with given magic number
    bool HasPositionWithMagic()
    {
        int total_positions = PositionsTotal();
        
        for(int i = 0; i < total_positions; i++)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0)
            {
                if(PositionGetInteger(POSITION_MAGIC) == m_magic)
                {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    // Get total number of orders with magic number
    int GetOrderCount()
    {
        int count = 0;
        int total_orders = OrdersTotal();
        
        for(int i = 0; i < total_orders; i++)
        {
            if(OrderGetTicket(i) > 0)
            {
                if(OrderGetInteger(ORDER_MAGIC) == m_magic)
                {
                    count++;
                }
            }
        }
        
        return count;
    }
    
    // Get total number of positions with magic number
    int GetPositionCount()
    {
        int count = 0;
        int total_positions = PositionsTotal();
        
        for(int i = 0; i < total_positions; i++)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0)
            {
                if(PositionGetInteger(POSITION_MAGIC) == m_magic)
                {
                    count++;
                }
            }
        }
        
        return count;
    }
    
    // Get total exposure (volume) for positions with magic number
    double GetTotalExposure()
    {
        double total_volume = 0.0;
        int total_positions = PositionsTotal();
        
        for(int i = 0; i < total_positions; i++)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0)
            {
                if(PositionGetInteger(POSITION_MAGIC) == m_magic)
                {
                    total_volume += PositionGetDouble(POSITION_VOLUME);
                }
            }
        }
        
        return total_volume;
    }
    
    // Utility function: Check if new bar
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
    
    // Utility function: Check breakout long (from reference patterns)
    bool IsBreakoutLong(double level, double tolerancePips = 0)
    {
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        double ask   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        return ask > level + tolerancePips * point * 10;
    }
    
    // Utility function: Check breakout short (from reference patterns)
    bool IsBreakoutShort(double level, double tolerancePips = 0)
    {
        double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        double bid   = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        return bid < level - tolerancePips * point * 10;
    }
    
    // Utility function: Check retest long (from reference patterns)
    bool IsRetestLong(double level, double RetestTolerancePips)
    {
        double point   = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        double tol     = RetestTolerancePips * point * 10;
        double lowBar  = iLow(_Symbol, PERIOD_CURRENT, 1);
        double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
        return (lowBar <= level + tol && closeBar > level);
    }
    
    // Utility function: Check retest short (from reference patterns)
    bool IsRetestShort(double level, double RetestTolerancePips)
    {
        double point    = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
        double tol      = RetestTolerancePips * point * 10;
        double highBar  = iHigh(_Symbol, PERIOD_CURRENT, 1);
        double closeBar = iClose(_Symbol, PERIOD_CURRENT, 1);
        return (highBar >= level - tol && closeBar < level);
    }
    
    // Utility function: Get indicator value
    double GetIndicatorValue(int handle, int buffer, int shift)
    {
        double value = 0;
        if(CopyBuffer(handle, buffer, shift, 1, value) > 0)
        {
            return value;
        }
        return 0;
    }
    
    // Utility function: Check trend long (from reference patterns)
    bool IsTrendLong(int fastHandle, int slowHandle, int SignalShift)
    {
        double fast0 = GetIndicatorValue(fastHandle, 0, SignalShift);
        double slow0 = GetIndicatorValue(slowHandle, 0, SignalShift);
        double fast1 = GetIndicatorValue(fastHandle, 0, SignalShift + 1);
        double slow1 = GetIndicatorValue(slowHandle, 0, SignalShift + 1);
        return (fast1 <= slow1 && fast0 > slow0);
    }
    
    // Utility function: Check trend short (from reference patterns)
    bool IsTrendShort(int fastHandle, int slowHandle, int SignalShift)
    {
        double fast0 = GetIndicatorValue(fastHandle, 0, SignalShift);
        double slow0 = GetIndicatorValue(slowHandle, 0, SignalShift);
        double fast1 = GetIndicatorValue(fastHandle, 0, SignalShift + 1);
        double slow1 = GetIndicatorValue(slowHandle, 0, SignalShift + 1);
        return (fast1 >= slow1 && fast0 < slow0);
    }
};
