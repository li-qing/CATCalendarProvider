Pod::Spec.new do |s|

  s.name          = "CATCalendarProvider"
  s.summary       = "A calendar data provider for UITableView/UICollectionView and a week collection view layout."
  s.description   = <<-DESC

                    ## calendar provider

                    1. support several modes using day/month/year component as item/section;

                    2. calculate number of items for given section for data sources of UITableView/UICollectionView

                    3. query dates for given sections/indexPaths and sections/indexPaths for given dates

                    4. support week filling mode, for example:

                        in Gregorian Calendar, using Sunday as first week day, for the section Apr 2015,
                     
                        Sun    Mon     Tue     Wed     Thu     Fri     Sat

                        3-29'  3-30'   3-31'   4-1     4-2     4-3     4-4

                        ...

                        4-26   4-27    4-28    4-29    4-30    5-1'    5-2'
                     
                        MM-dd' would be included in week filling mode.


                    ## week collection view layout

                    1. support weekday indicator/section header/section footer.

                    2. scrollDirection/indicatorHeight/headerHeight/footerHeight/sectionInsets/itemInsets/itemSize are configurable.

                   DESC

  s.homepage      = "https://github.com/li-qing/CATCalendarProvider"
  s.author        = { "li-qing" => "lshhch@gmail.com" }
  s.license       = "MIT"

  s.version       = "1.0.0"
  s.platform      = :ios, "6.0"
  s.requires_arc  = true
  s.frameworks    = 'Foundation', 'UIKit' 
  s.source        = { :git => "https://github.com/li-qing/CATCalendarProvider.git", :tag => s.version.to_s }
  s.source_files  = "CATCalendarProvider/*.{h,m}"

end
