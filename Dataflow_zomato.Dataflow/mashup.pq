[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared DefaultDestination = Lakehouse.Contents([EnableFolding = false]){[workspaceId = "65ce72b1-8c61-4309-9882-159de50b6d7f"]}[Data]{[lakehouseId = "10d29501-9702-49bf-bf33-5ab9037c978c"]}[Data];
[BindToDefaultDestination = true]
shared #"ZomatoRestaurantDataset csv" = let
  Source = Lakehouse.Contents([HierarchicalNavigation = null, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "65ce72b1-8c61-4309-9882-159de50b6d7f"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "10d29501-9702-49bf-bf33-5ab9037c978c"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "Files", ItemKind = "Folder"]}[Data],
  #"Navigation 4" = #"Navigation 3"{[Name = "ZomatoRestaurantDataset.csv"]}[Content],
  #"Imported CSV" = Csv.Document(#"Navigation 4", [Delimiter = ",", Columns = 21, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"RestaurantID", Int64.Type}, {"RestaurantName", type text}, {"CountryCode", Int64.Type}, {"City", type text}, {"Address", type text}, {"Locality", type text}, {"LocalityVerbose", type text}, {"Longitude", type number}, {"Latitude", type number}, {"Cuisines", type text}, {"AverageCostForTwo", Int64.Type}, {"Currency", type text}, {"HasTableBooking", type text}, {"HasOnlineDelivery", type text}, {"IsDeliveringNow", type text}, {"SwitchToOrderMenu", type text}, {"PriceRange", Int64.Type}, {"AggregateRating", type number}, {"RatingColor", type text}, {"RatingText", type text}, {"Votes", Int64.Type}}),
  #"Renamed columns" = Table.RenameColumns(#"Changed column type", {{"AggregateRating", "Rating"}}),
  #"Trimmed text" = Table.TransformColumns(#"Renamed columns", {{"RestaurantName", each Text.Trim(_), type nullable text}}),
  #"Trimmed text 1" = Table.TransformColumns(#"Trimmed text", {{"RestaurantName", each Text.Trim(_), type nullable text}}),
  #"Uppercased text" = Table.TransformColumns(#"Trimmed text 1", {{"RestaurantName", each Text.Upper(_), type nullable text}}),
#"Cleaned RestaurantName"=table.transformColumns(#"Uppercased text",{{"Resturant Name", each Text.Replace(Text.Remove(_,{"?"}),"_",""),type nullable text}}),
  #"Cleaned text" = Table.TransformColumns(#"Uppercased text", {{"RestaurantName", each Text.Clean(_), type nullable text}}),
  #"Removed duplicates" = Table.Distinct(#"Cleaned text", {"RestaurantID"}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Removed duplicates", "YearOpened", each 2023), {{"YearOpened", Int64.Type}}),
  #"Added custom 1" = Table.AddColumn(#"Added custom", "Address_Clean", each let Address1 = if [Locality] <> null then Text.Replace([Address],[Locality],"") else [Address], Address2 = if [City] <> null then Text.Replace(Address1, [City],"") else Address1 in Text.Trim(Text.Trim(Address2,{","," "}))),
  #"Reordered columns" = Table.ReorderColumns(#"Added custom 1", {"RestaurantID", "RestaurantName", "CountryCode", "City", "Address", "Address_Clean", "Locality", "LocalityVerbose", "Longitude", "Latitude", "Cuisines", "AverageCostForTwo", "Currency", "HasTableBooking", "HasOnlineDelivery", "IsDeliveringNow", "SwitchToOrderMenu", "PriceRange", "Rating", "RatingColor", "RatingText", "Votes", "YearOpened"}),
  #"Added custom 2" = Table.TransformColumnTypes(Table.AddColumn(#"Reordered columns","Locality_Clean", each try if [Locality] = null then null else if [City] = null then Text.Trim([Locality])
else Text.Trim(Text.Replace([Locality],[City],"")) otherwise null), {{"Locality_Clean", type text}})
in
  #"Added custom 2";
