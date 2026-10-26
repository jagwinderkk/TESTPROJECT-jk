[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared DefaultDestination = Lakehouse.Contents([EnableFolding = false]){[workspaceId = "65ce72b1-8c61-4309-9882-159de50b6d7f"]}[Data]{[lakehouseId = "b3df263a-507a-4ea2-9bb3-c608c52bf832"]}[Data];
[BindToDefaultDestination = true]
shared ZomatoRestaurantDataset = let
  Source = Excel.Workbook(Web.Contents("https://sdktekservices-my.sharepoint.com/personal/jagwinder_kaura_sdktek_com/Documents/Apps/Microsoft Power Query/Uploaded Files/ZomatoRestaurantDataset.xlsx"), null, true),
  #"Navigation 1" = Source{[Item = "ZomatoRestaurantDataset", Kind = "Sheet"]}[Data],
  #"Promoted headers" = Table.PromoteHeaders(#"Navigation 1", [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"RestaurantID", Int64.Type}, {"RestaurantName", type text}, {"CountryCode", Int64.Type}, {"City", type text}, {"Address", type text}, {"Locality", type text}, {"LocalityVerbose", type text}, {"Longitude", type number}, {"Latitude", type number}, {"Cuisines", type text}, {"AverageCostForTwo", Int64.Type}, {"Currency", type text}, {"HasTableBooking", type text}, {"HasOnlineDelivery", type text}, {"IsDeliveringNow", type text}, {"SwitchToOrderMenu", type text}, {"PriceRange", Int64.Type}, {"AggregateRating", type number}, {"RatingColor", type text}, {"RatingText", type text}, {"Votes", Int64.Type}, {"Year", Int64.Type}})
in
  #"Changed column type";
