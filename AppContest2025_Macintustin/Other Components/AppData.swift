/**
 @file AppData.swift
 @project AppContest2025_Macintustin
 
 @brief Centralized static data storage for the application.
 @details
  AppData provides static dictionaries containing key application data used across
  the project, including:

  - PhotoDatabase: Maps location names to arrays of image asset names representing
    default photos for various places.
  - defaultLikeCounts: Initial like counts associated with each location,
    representing popularity or user interest.
  - defaultComments: Sample user comments associated with locations, used as
    fallback or default feedback entries.

  This struct centralizes hardcoded or preloaded content to facilitate data
  management and reuse throughout the app's UI components and logic.
 
 @author 赵禹惟
 @date 2025/4/18
 */

import Foundation

struct AppData {
    static let PhotoDatabase: [String: [String]] = [
        "Ocean University of China Xihaian Campus": ["oucwest_1", "oucwest_2", "oucwest_3"],
        "Haijun Park": ["haijunpark_1", "haijunpark_2", "haijunpark_3"],
        "Mangrove Tree Town Square": ["hongshulin_1", "hongshulin_2"],
        "Zhanqiao Scenic Area": ["zhanqiao_1", "zhanqiao_2", "zhanqiao_3"],
        "Badaguan Scenic Area": ["badaguan_1", "badaguan_2"],
        "Qingdao Shilaoren Bathing Beach": ["shilaoren_1"],
        "Olympics Sailing Center Aofan Ocean Culture Tourist Zone": ["aofan_1", "aofan_2"],
        "Laoshan Mountain": ["laoshan_1", "laoshan_2"],
        "Ocean University of China Laoshan Campus": ["oucLaoshan_1", "oucLaoshan_2", "oucLaoshan_3"],
        "Qingdao Xinzhan Bridge - Shenlan Zhiguang": ["xinzhanqiao_1", "xinzhanqiao_2"]
    ]
    
    static let defaultLikeCounts: [String: Int] = [
        "Laoshan Mountain": 10086,
        "Olympics Sailing Center Aofan Ocean Culture Tourist Zone": 1023,
        "Qingdao Shilaoren Bathing Beach": 8657,
        "Zhanqiao Scenic Area": 888,
        "Badaguan Scenic Area": 623,
        "Ocean University of China Laoshan Campus": 1668,
        "Ocean University of China Xihaian Campus": 500,
        "Haijun Park": 168,
        "Mangrove Tree Town Square": 90,
        "Qingdao Xinzhan Bridge - Shenlan Zhiguang": 96,
        "Qingdao Yuehehua Street": 23,
        "Wuyue Square (Qingdao West Coast Branch)": 88
    ]
    
    static let defaultComments: [String: [String]] = [
        "Badaguan Scenic Area": [
            "Not bad, we can still see the architecture of the Republic of China"
        ],
        "Ocean University of China Laoshan Campus":[
            "Good location, easy to travel",
            "The cherry blossoms in spring are very beautiful",
            "There are many canteens with rich dishes"
        ],
        "Zhanqiao Scenic Area": [
            "Serious commercialization"
        ],
        "Qingdao Shilaoren Bathing Beach": [
            "The beach is most beautiful at sunset. Highly recommended!"
        ],
        "Laoshan Mountain": [
            "Nice view. Recommended!",
            "A little regret, to catch up with the typhoon closed the mountain"
        ],
        "Ocean University of China Xihaian Campus": [
            "The scenery is pleasant and suitable for study",
            "The library is spectacular, but it's not built yet",
            "The location is remote!!!",
            "Food in canteen needs to be strengthened!",
            "I love this place!"
        ],
        "Ocean University of China West Coast Campus": [
            "The scenery is pleasant and suitable for study",
            "The library is spectacular, but it's not built yet",
            "The location is remote!!!",
            "Food in canteen needs to be strengthened!"
        ],
        "Haijun Park": [
            "Good for hanging out after dinner",
            "Beautiful sea view !"
        ],
        "Mangrove Tree Town Square": [
            "Resort for leisure and food",
            "Price is too HIGH!!!"
        ]
    ]
}
