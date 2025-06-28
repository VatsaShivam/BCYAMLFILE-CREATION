pageextension 50106 MyExtension extends "Custom Order Card"
{
    actions
    {
        addlast(processing)
        {
            group(Yaml)
            {
                action(ReadYamlFile)
                {
                    Caption = 'Read Yaml File';

                    trigger OnAction()
                    var
                        JsonObject, UberCustomer, HomeLocation, WorkLocation, RecentTrip : JsonObject;
                        ResponseText: Text;
                        UberCustomerJson, Value, PromoCode : JsonToken;
                        PromoCodes: JsonArray;

                        MainDict, HomeLocDict, WorkLocDict, RecentTripDict : Dictionary of [Text, Text];
                        PromoList, FieldList, HomeLocList, WorkLocList, RecentTripList : List of [Text];

                        i, Customercancelledtrip, Recenttripfare, RecenttripratingStar : Integer;

                        Key1, TempText, MainDictMessage, CustomerId, CustomerName, CustomerEmail, CustomerPhone, SignUpdate, Lastlogin,
                        totaltrip, cancelledtrip, rating, preferred_payment_method, wallet_balance, loyalty_tier, app_version,
                        push_notifications_enabled, language_preference, last_feedback, device_type, referral_code, Homelatitude,
                        Homelongitude, Homeaddress, HomeMessage, Worklatitude, Worklongitude, Workaddress, WorkMessage, Recenttripid,
                        Recentdate, Recentsource, Recentdestination, Recentfare, Recentdrivername, Recentvehicletype, Recenttriprating,
                        RecentTripMessage : Text;

                        CustomerSignUp: Date;
                        CustomerLastLogin, RecentTripdate : DateTime;
                        Customertotaltrip, Customerrating, CustomerWalletBalance : Decimal;
                        push_enabled: Boolean;

                    begin
                        ResponseText := @'uber_customer:
                            customer_id: "c123456789"
                            name: "Shivam Mishra"
                            email: "shivam.mishra@email.com"
                            phone_number: "+91-9876543210"
                            signup_date: "2022-03-15"
                            last_login: "2025-06-16 21:45:00"
                            total_trips: 15.2
                            cancelled_trips: 7
                            rating: 4.89
                            preferred_payment_method: "credit_card"
                            wallet_balance: 350.75
                            home_location:
                                latitude: 28.6139
                                longitude: 77.2090
                                address: "Connaught Place, New Delhi"
                            work_location:
                                latitude: 28.5355
                                longitude: 77.3910
                                address: "Sector 62, Noida"
                            recent_trip:
                                trip_id: "t987654321"
                                date: "2025-06-15 18:30:00"
                                source: "Connaught Place, New Delhi"
                                destination: "Indira Gandhi International Airport, New Delhi"
                                fare: 540.00
                                driver_name: "Amit Verma"
                                vehicle_type: "Uber Premier"
                                trip_rating: 5
                            loyalty_tier: "Gold"
                            promo_codes_used: ["WELCOME100", "SUMMER25", "RIDEFAST"]
                            app_version: "5.12.3"
                            push_notifications_enabled: true
                            language_preference: "en-IN"
                            last_feedback: "Great ride, very clean car!"
                            device_type: "Android"
                            referral_code: "SMUBER2025"
                        ';

                        FieldList.Add('customer_id');
                        FieldList.Add('name');
                        FieldList.Add('email');
                        FieldList.Add('phone_number');
                        FieldList.Add('signup_date');
                        FieldList.Add('last_login');
                        FieldList.Add('total_trips');
                        FieldList.Add('cancelled_trips');
                        FieldList.Add('rating');
                        FieldList.Add('preferred_payment_method');
                        FieldList.Add('wallet_balance');
                        FieldList.Add('loyalty_tier');
                        FieldList.Add('app_version');
                        FieldList.Add('push_notifications_enabled');
                        FieldList.Add('language_preference');
                        FieldList.Add('last_feedback');
                        FieldList.Add('device_type');
                        FieldList.Add('referral_code');

                        HomeLocList.Add('latitude');
                        HomeLocList.Add('longitude');
                        HomeLocList.Add('address');

                        WorkLocList.Add('latitude');
                        WorkLocList.Add('longitude');
                        WorkLocList.Add('address');

                        RecentTripList.Add('trip_id');
                        RecentTripList.Add('date');
                        RecentTripList.Add('source');
                        RecentTripList.Add('destination');
                        RecentTripList.Add('fare');
                        RecentTripList.Add('driver_name');
                        RecentTripList.Add('vehicle_type');
                        RecentTripList.Add('trip_rating');

                        JsonObject.ReadFromYaml(ResponseText);

                        if JsonObject.Get('uber_customer', UberCustomerJson) then begin
                            UberCustomer := UberCustomerJson.AsObject();

                            clear(MainDict);
                            Clear(HomeLocDict);
                            Clear(WorkLocDict);
                            Clear(RecentTripDict);
                            Clear(PromoList);


                            foreach Key1 in FieldList do begin
                                if UberCustomer.Get(Key1, Value) then
                                    MainDict.Add(Key1, Value.AsValue().AsText());
                            end;


                            if UberCustomer.Get('home_location', Value) then begin
                                HomeLocation := Value.AsObject();
                                clear(HomeLocDict);
                                foreach Key1 in HomeLocList do begin
                                    if HomeLocation.Get(Key1, Value) then
                                        HomeLocDict.Add(Key1, Value.AsValue().AsText());
                                end;
                                MainDict.Add('home_location', FlattenDict(HomeLocDict));
                            end;


                            if UberCustomer.Get('work_location', Value) then begin
                                WorkLocation := Value.AsObject();
                                Clear(WorkLocDict);
                                foreach Key1 in WorkLocList do begin
                                    if WorkLocation.Get(Key1, Value) then
                                        WorkLocDict.Add(Key1, Value.AsValue().AsText());
                                end;
                                MainDict.Add('work_location', FlattenDict(WorkLocDict));
                            end;


                            if UberCustomer.Get('recent_trip', Value) then begin
                                RecentTrip := Value.AsObject();
                                Clear(RecentTripDict);
                                foreach Key1 in RecentTripList do begin
                                    if RecentTrip.Get(Key1, Value) then
                                        RecentTripDict.Add(Key1, Value.AsValue().AsText());
                                end;
                                MainDict.Add('recent_trip', FlattenDict(RecentTripDict));
                            end;


                            if UberCustomer.Get('promo_codes_used', Value) then begin
                                PromoCodes := Value.AsArray();
                                Clear(PromoList);
                                for i := 0 to PromoCodes.Count() - 1 do begin
                                    PromoCodes.Get(i, PromoCode);
                                    PromoList.Add(PromoCode.AsValue().AsText());
                                end;
                                TempText := '';
                                foreach Key1 in PromoList do
                                    TempText += Key1 + '; ';
                                MainDict.Add('promo_codes_used', TempText);
                            end;

                            MainDictMessage :=
                                @'Customer Info:\
                                Customer Id: %1\
                                Customer Name: %2\
                                Email: %3\
                                Phone number: %4\
                                Signup date: %5\
                                Last login: %6\
                                Total trips: %7\
                                Cancelled trips: %8\
                                Rating: %9\
                                Preferred payment method: %10\
                                Wallet balance: %11\
                                Loyalty tier: %12\
                                App version: %13\
                                Push notifications enabled: %14\
                                Language preference: %15\
                                Last feedback: %16\
                                Device type: %17\
                                Referral code: %18';

                            HomeMessage :=
                                @'Home Location:\
                                Latitude: %1\
                                Longitude: %2\
                                Address: %3
                                ';

                            WorkMessage :=
                                @'Work Location:\
                                Latitude: %1\
                                Longitude: %2\
                                Address: %3
                                ';

                            RecentTripMessage :=
                                @'Recent Trip Location:\
                                Trip_id: %1\ 
                                Date: %2\
                                Source: %3\
                                Destination: %4\
                                Fare: %5\
                                Driver name: %6\
                                Vehicle type: %7\
                                Trip rating: %8
                                ';

                            CustomerId := MainDict.Get('customer_id');
                            CustomerName := MainDict.Get('name');
                            CustomerEmail := MainDict.Get('email');
                            CustomerPhone := MainDict.Get('phone_number');
                            SignUpdate := MainDict.Get('signup_date');
                            Evaluate(CustomerSignUp, SignUpdate);
                            Lastlogin := MainDict.Get('last_login');
                            Evaluate(CustomerLastLogin, Lastlogin);
                            totaltrip := MainDict.Get('total_trips');
                            Evaluate(Customertotaltrip, totaltrip);
                            cancelledtrip := MainDict.Get('cancelled_trips');
                            Evaluate(Customercancelledtrip, cancelledtrip);
                            rating := MainDict.Get('rating');
                            Evaluate(Customerrating, rating);
                            preferred_payment_method := MainDict.Get('preferred_payment_method');
                            wallet_balance := MainDict.Get('wallet_balance');
                            Evaluate(CustomerWalletBalance, wallet_balance);
                            loyalty_tier := MainDict.Get('loyalty_tier');
                            app_version := MainDict.Get('app_version');
                            push_notifications_enabled := MainDict.Get('push_notifications_enabled');
                            Evaluate(push_enabled, push_notifications_enabled);
                            language_preference := MainDict.Get('language_preference');
                            last_feedback := MainDict.Get('last_feedback');
                            device_type := MainDict.Get('device_type');
                            referral_code := MainDict.Get('referral_code');

                            foreach key1 in HomeLocList do begin
                                case Key1 of
                                    'latitude':
                                        Homelatitude := HomeLocDict.Get('latitude');
                                    'longitude':
                                        Homelongitude := HomeLocDict.Get('longitude');
                                    'address':
                                        Homeaddress := HomeLocDict.Get('address');
                                end;
                            end;

                            foreach key1 in WorkLocList do begin
                                case Key1 of
                                    'latitude':
                                        Worklatitude := WorkLocDict.Get('latitude');
                                    'longitude':
                                        Worklongitude := WorkLocDict.Get('longitude');
                                    'address':
                                        Workaddress := WorkLocDict.Get('address');
                                end;
                            end;

                            foreach key1 in RecentTripList do begin
                                case Key1 of
                                    'trip_id':
                                        Recenttripid := RecentTripDict.Get('trip_id');
                                    'date':
                                        Recentdate := RecentTripDict.Get('date');
                                    'source':
                                        Recentsource := RecentTripDict.Get('source');
                                    'destination':
                                        Recentdestination := RecentTripDict.Get('destination');
                                    'fare':
                                        Recentfare := RecentTripDict.Get('fare');
                                    'driver_name':
                                        Recentdrivername := RecentTripDict.Get('driver_name');
                                    'vehicle_type':
                                        Recentvehicletype := RecentTripDict.Get('vehicle_type');
                                    'trip_rating':
                                        Recenttriprating := RecentTripDict.Get('trip_rating');
                                end;
                            end;

                            Evaluate(RecentTripdate, Recentdate);
                            Evaluate(Recenttripfare, Recentfare);
                            Evaluate(RecenttripratingStar, Recenttriprating);

                            Message(MainDictMessage, CustomerId, CustomerName, CustomerEmail, CustomerPhone, CustomerSignUp, CustomerLastLogin,
                            Customertotaltrip, Customercancelledtrip, Customerrating, preferred_payment_method, wallet_balance, loyalty_tier,
                            app_version, push_enabled, language_preference, last_feedback, device_type, referral_code);
                            Message('Promo Codes: %1', MainDict.Get('promo_codes_used'));
                            Message(HomeMessage, Homelatitude, Homelongitude, Homeaddress);
                            Message(WorkMessage, Worklatitude, Worklongitude, Workaddress);
                            Message(RecentTripMessage, Recenttripid, RecentTripdate, Recentsource, Recentdestination, Recenttripfare, Recentdrivername,
                            Recentvehicletype, RecenttripratingStar);
                        end;
                    end;
                }
            }
        }
        addlast(Yaml)
        {
            action(WriteToTaml)
            {
                Caption = 'Write Yaml File';
                trigger OnAction()
                var
                    ProductsArray, TagsArray : JsonArray;
                    Product, RootObject : JsonObject;
                    YamlText, FileName, MimeType : Text;
                    OutS: OutStream;
                    InStr: InStream;
                    TempBlob: Codeunit "Temp Blob";
                begin
                    Product.Add('id', 101);
                    Product.Add('name', 'Laptop');
                    Product.Add('price', 1200.5);
                    Product.Add('inStock', true);

                    TagsArray.Add('portable');
                    TagsArray.Add('electronics');
                    TagsArray.Add('mobile');
                    TagsArray.Add('sale');
                    Product.Add('tags', TagsArray);

                    ProductsArray.Add(Product);

                    clear(Product);
                    Product.Add('id', 102);
                    Product.Add('name', 'Smartphone');
                    Product.Add('price', 799.99);
                    Product.Add('inStock', false);

                    Product.Add('tags', TagsArray);
                    ProductsArray.Add(Product);

                    RootObject.Add('products', ProductsArray);

                    FileName := 'Products.yaml';
                    MimeType := 'application/yaml';

                    //Download Yaml File
                    TempBlob.CreateOutStream(OutS);
                    RootObject.WriteToYaml(OutS);
                    TempBlob.CreateInStream(InStr);
                    DownloadFromStream(InStr, '', '', MimeType, FileName);

                    RootObject.WriteToYaml(YamlText);
                    Message('YAML output:\%1', YamlText);
                end;
            }
        }
    }

    procedure FlattenDict(Dict: Dictionary of [Text, Text]): Text
    var
        FlatText: Text;
        Key1: Text;
    begin
        FlatText := '';
        foreach Key1 in Dict.Keys do
            FlatText += Key1 + ':' + Dict.Get(Key1) + ';';
        exit(FlatText);
    end;
}
