-- create database and use that database
CREATE DATABASE csc_675;
USE csc_675;

-- CREATE TABLES -- 
-- User (user_id: int, friends: varchar, name: varchar, helpful: int; join_date: datetime, review_count: int)
-- I changed friends to be the count of friends, not a list of different user_id. makes things simpler
-- join_date uses DATE rather than DATETIME. All we really need is year:month:date not the hours:minutes:seconds
-- InnoDB is the default value for engine, which allows for BTREE indexing
-- got rid of review count, we can compute the review count with one of sql query
CREATE TABLE user(
    user_id INTEGER AUTO_INCREMENT,
    friends INTEGER DEFAULT 0,
    name VARCHAR(50) NOT NULL,
    helpful INTEGER DEFAULT 0,
    join_date DATE NOT NULL,
    PRIMARY KEY (user_id)
) ENGINE = InnoDB;

-- Business (business_id: int, name: varchar, address: varchar, city: varchar, state: varchar, postal _code: varchar, rating: tinyint, is_open: tinyint, review_count: int)
-- state is 2 letters
-- is_open is Y/N
-- InnoDB is the default value for engine, which allows for BTREE indexing
-- got rid of rating, we can compute rating with sql query
-- got rid of review counts, we can compute it with sql query
CREATE TABLE business(
    business_id INTEGER AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(50) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state CHAR(2) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    is_open CHAR(1),
    PRIMARY KEY (business_id)
) ENGINE = InnoDB;

-- Review (review_id: int, text: text, rating: tinyint, useful: int, date: datetime)
-- text changed to summary, text is a reserved word 
-- had to add business_id because review is a weak entity that relies on business
-- had to add user_id because of participation constraints
CREATE TABLE review(
    review_id INTEGER AUTO_INCREMENT,
    summary TEXT NOT NULL,
    rating TINYINT NOT NULL,
    useful TINYINT,
    created_date DATE NOT NULL,
    business_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (review_id, business_id),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
        ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
        ON DELETE CASCADE
);

-- Photo (photo_id: int, date: datetime, caption: varchar, label: varchar)
-- date changed to upload_date, date is a reserved word 
-- had to add business_id because photo is a weak entity that relies on business
-- had to add user_id because of participation constraints
CREATE TABLE photo(
    photo_id INTEGER AUTO_INCREMENT,
    upload_date DATE NOT NULL,
    caption VARCHAR(100),
    label VARCHAR(10),
    business_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY (photo_id, business_id),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
        ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
        ON DELETE CASCADE
);

-- Category (name: varchar)
-- had to add business_id because category is a weak entity that relies on business
CREATE TABLE category(
    name varchar(20),
    business_id INTEGER NOT NULL,
    PRIMARY KEY (name, business_id),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
        ON DELETE CASCADE
);

-- Hour (day: varchar, time: varchar)
-- had to add business_id because hour is a weak entity that relies on business

-- Could have ENUM('monday', 'tuesday', ... , 'sunday') for the day type
CREATE TABLE hour(
    day CHAR(3),
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    business_id INTEGER NOT NULL,
    PRIMARY KEY (day, business_id),
    FOREIGN KEY (business_id) REFERENCES business(business_id)
        ON DELETE CASCADE
);

-- implementing the bottom two are a pain in the butt
-- i think we should drop user owning a business 
-- as well as reviews containing photos, just make them seperate. 
CREATE TABLE user_owns_business(
    user_id INTEGER NOT NULL,
    business_id INTEGER NOT NULL,
    PRIMARY KEY (user_id, business_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (business_id) REFERENCES business(business_id)
        ON DELETE CASCADE
);
CREATE TABLE review_contains_photo(
    review_id INTEGER NOT NULL,
    photo_id INTEGER NOT NULL,
    PRIMARY KEY (review_id, photo_id),
    FOREIGN KEY (review_id) REFERENCES review(review_id)
        ON DELETE CASCADE,
    FOREIGN KEY (photo_id) REFERENCES photo(photo_id)
        ON DELETE CASCADE
);

-- CREATE INDEX --
-- Engine innoDB uses BTREE indexing not HASH indexing
CREATE INDEX user_index ON user(join_date);
CREATE INDEX business_index ON business(state, name);
CREATE INDEX businessHours ON hour(day, open_time, close_time);

-- CREATE VIEW --
CREATE VIEW business_name_and_state AS 
    SELECT business_id AS "id", name AS "business name", state 
    FROM business
    ORDER BY business_id;

-- INSERT DATA --
INSERT INTO user (name, join_date, friends, helpful) VALUES
    ("Susan", "2008-09-24", 0, 0),
    ("Daipayan", "2015-09-15", 0, 0),
    ("Andy", "2016-07-21", 0, 0),
    ("Jonathan", "2014-08-04", 0, 0),
    ("Shashank", "2017-06-18", 0, 0),
    ("Stacey X Joe", "2014-8-27", 0, 0),
    ("Lindsay", "2016-02-02", 0, 0),
    ("Joshua", "2013-03-20", 0, 0),
    ("Mike", "2014-07-11", 0, 8),
    ("Mitch", "2013-03-20", 0, 2),
    ("Andrea", "2017-08-25", 0, 0),
    ("F", "2015-10-4", 0, 0),
    ("Jessica", "2011-01-5", 0, 0),
    ("Alex", "2017-08-23", 0, 0),
    ("Kara", "2017-11-21", 0, 0),
    ("Teresa", "2014-10-26", 0, 0),
    ("Danielle", "2015-07-19", 0, 2),
    ("Shawn", "2014-06-19", 0, 2),
    ("Love America", "2016-05-01", 0, 0),
    ("Matthew", "2015-05-07", 0, 5),
    ("Kim", "2015-03-01", 0, 0), 
    ("Ying", "2012-02-09", 0, 0), 
    ("John", "2012-10-09", 0, 0), 
    ("Kaye", "2014-04-11", 0, 0), 
    ("Matt", "2013-07-02", 0, 0),
    ("Tim", "2009-11-03", 0, 0),
    ("Sandra", "2015-04-05", 0, 0), 
    ("Aisha", "2009-05-08", 0, 0), 
    ("Dana", "2016-07-08", 0, 0), 
    ("Teresa", "2016-03-01", 0, 0), 
    ("Joe", "2015-12-30", 0, 0),
    ("Gary", "2011-05-01", 0, 2), 
    ("Kerry", "2017-02-03", 0, 0), 
    ("Sarah", "2016-07-14", 0, 0), 
    ("Rosemary", "2016-10-20", 0, 0),
    ("Frank", "2017-06-21", 0, 0), 
    ("Chris", "2011-07-16", 0, 0), 
    ("Tiffany", "2013-05-23", 0, 0), 
    ("Jamie", "2015-08-06", 0, 0);
    
INSERT INTO business (name, address, city, state, postal_code, is_open) VALUES
    ("Minhas Micro Brewery", "1314 44 Avenue NE", "Calgary", "AB", "T2E 6L6", "Y"),
    ("CK'S BBQ & Catering", "Somewhere in", "Henderson", "NV", "89002", "N"),
    ("La Bastringue", "1335 rue Beaubien E", "Montreal", "QC", "H2G 1K7", "N"),
    ("Geico Insurance", "211 W Monroe St", "Phoenix", "AZ", "85003", "Y"),
    ("Action Engine", "2005 Alyth Place SE", "Calgary", "AB", "T2H 0N5", "Y"),
    ("The Coffee Bean & Tea Leaf", "20235 N Cave Creek Rd, Ste 1115", "Phoenix", "AZ", "85024", "Y"),
    ("Bnc Cake House", "631 Bloor St W", "Toronto", "ON", "M6G 1K8", "N"),
    ("Thai One On", "3417 Derry Road E, Unit 103", "Mississauga", "ON", "L4T 1A8", "Y"),
    ("Filberto's Mexican Food", "1440 N. Dysart Ave", "Avondale", "AZ", "85323", "Y"),
    ("Maggie & Stella's Gifts", "209 Oakland Ave", "Pittsburgh", "PA", "15213", "Y"),
    ("Southern Accent Restaurant", "595 Markham Street", "Toronto", "ON", "M6G 2L7", "N"),
    ("Original Hamburger Works", "2801 N 15th Ave", "Phoenix", "AZ", "85007", "Y"),
    ("North Haven Barber Shop", "4404 14 Street NW", "Calgary", "AB", "T2K", "Y"),
    ("Safeway Food & Drug", "1200 37 St SW", "Calgary", "AB", "T3C 1S2", "Y"),
    ("Harlow", "438 Place Jacques Cartier", "Montreal", "QC", "H2Y 3B3", "N"),
    ("Citi Trends", "703 N Rancho Dr", "Las Vegas", "NV", "89106", "Y"), 
    ("Nevada Title And Payday Loans", "1549 N Rancho Dr", "Las Vegas", "NV", "89106", "N"),
    ("CakesbyToi", "3940 Martin Luther King Blvd, Ste 101", "Las Vegas", "NV", "89106", "N"),
    ("Park Stone Pavers", "Somewhere in", "Las Vegas", "NV", "89031", "Y"), 
    ("Rally's Hamburgers", "3040 Carnegie Ave", "Cleveland", "OH", "44115", "Y"),
    ("Rib Shop", "4131 N 83rd Ave", "Phoenix", "AZ", "85033", "Y"),
    ("Mabel's Bakery", "746 Street Clair Avenue W", "Toronto", "ON", "M6C 1B5", "Y"),
    ("Salsitas", "7745 W Thomas Rd", "Phoenix", "AZ", "85033", "Y"), 
    ("Los Toros Numero 2", "1204 Bear Ln", "Monticello", "IL", "61856", "N"), 
    ("ADT Security Services, Inc", "Somewhere in", "Phoenix", "AZ", "85001", "Y"),
    ("The Coffee Mill Restaurant", "99 Yorkville Avenue", "Toronto", "ON", "M5R 3K5", "N"),
    ("Laurier Optical", "1-905 Britannia Road West", "Mississauga", "ON", "L5V 2X8", "Y"),
    ("Teresa Pizzeria", "9525 State Rt 14", "Streetsboro", "OH", "44241", "Y");
    
INSERT INTO review (summary, rating, useful, created_date, business_id, user_id) VALUES
    ("Amazing!!! We did the tour for 4 and had such a great time. Tanner was very informative and very generous with beer samples :p It was an awesome experience seeing behind the scenes. What an awesome time. It was a better than we expected Would 10/10 recommend!!!", 5, 0, "2018-10-30", 1, 1),
    ("Fun tour! You see the entire production process from grain to can! Absolutely loved the samples we were given and was blown away by how delicious the beers were. I'm not too much of a beer person, but I think Minhas is going to change that real soon.", 5, 1, "2018-05-05", 1, 6),
    ("Came here with my labmate since we were exploring Annecy during our free time (outside of our research conference) and stumbled across their prix fixe menu.  We were surprised by how cozy the restaurant was and really enjoyed the food.  I got the fried frogs legs, steak, and ice cream.  Overall, pretty great food and good ambiance.  Would come back the next time I'm in Annecy!", 4, 1, "2016-08-28", 3, 8),
    ("They overcharge you and don't cancel your policy when you ask them too. I switched to Progressive and have been much happier... as has my wallet.", 1, 1, "2018-11-21", 4, 7),
    ("One of the worst insurance companies ever. Underwriting department is horrible, they make mistakes with forms that they need from you and they have a bad attitude. Company also changes monthly premium every 6 months by a lot. Waste of time. Not interested in giving them my business.", 1, 5, "2018-12-06", 4, 10),
    ("Called for information about repairing my lawnmower. They told me a one hour turnaround to fix my lawnmower. I drove all the way out there I arrive they tell me we will have the lawn more for a week or longer depending on what's needed to be done. The person on the phone should have been more clear and more detailed about that. I called many other service repair places and they all explained how long they would have my machine for.", 1, 0, "2018-12-06", 5, 5),
    ("I've never been to this Coffee Bean and I must say I am impressed. The employees are friendly and there's plenty of seating. (Not just two tables- like some places I've been to). I will definitely return. Thank you for a positive and friendly experience.", 5, 0, "2016-06-17", 6, 5),
    ("Great service, great coffee, good free parking, sketchy looking patrons.  I guess that's why they have a security guard inside the store!", 4, 0, "2018-01-05", 6, 3),
    ("I've Been Here 4 Times & Each Time The Staff Is So Friendly & Willing To Answer Questions or Concerns. They Offer Parking & It's A Pretty Spacious Location. I Just Love The Area & It's So Central To Everything. They Definitely Make Their Drinks With Care Which I Appreciate!", 5, 0, "2018-07-17", 6, 9),
    ("Nice staff, good drinks. Quiet setting. My kind of coffee bean. Easy access and the staff works with you to make sure you like your drinks. Ill be back!", 4, 0, "2019-03-17", 6, 6),
    ("Unique korean pastries! Cool interior! Friendly service!", 5, 0, "2013-12-01", 7, 6),
    ("Great quick service food. Large filled burritos filled with stuff.  Late night filling food. Large variety of Mexican food.", 5, 0, "2018-10-12", 9, 4),
    ("Worst Mexican food I haven't eaten there since last year. Won't come back burrito got soggy", 1, 0, "2018-10-15", 9, 6),
    ("I LOVED this shop!!! The customer service is outstanding!  It has items from Vera Bradley, Lily Pulitzer, Kate Spade, and other favorites. They have a few Pittsburgh items, all kinds of things for kids, greeting cards, jewelry, and so much more. You could spend a long time in there because there is a lot to look at. If you are in Oakland you should stop in.", 5, 0, "2015-11-07", 10, 6),
    ("My husband and I bought a Groupon for a Minhas Brewery tour including food and a growler. Tanner was our tour guide and we had such a wonderful time with him. I have been a part of many brewery tours, and Tanner was fun, laid back, open to questions, took his time making sure we enjoyed ourselves and making our experience memorable. The beers we're great too Thanks, Minhas! We had a great date night away from our toddler!", 5, 0, "2018-11-1", 1, 15),
    ("Michael was outstanding and a great tour guide for the brewery !! Awesome pizza , wings and 'oh boy' the beer was great !!You guys are very generous  with sampling - so it was lots of FUN !!!", 5, 0, "2017-10-13", 1, 17),
    ("Michael was superrrrrr coool! Best tour guide ever! This tour was superrrr informative and super fun. We got to see how everything was made as well as tasted mannyyyy very different types of beer and they were allll yummy  i highly recommend the tour. It's super cheap because the amount of tasting beers and free stuff you get to take is amazing! Definitely ask for Michael he know sooo much about beer. He's super great. The best tour guide everrrr!!!!!", 5, 0, "2018-03-21", 1, 11),
    ("Michael was an awesome tour guide. Learned a lot of information and he was very bubbly, like the beer! The pizza was good too.", 4, 0, "2018-04-06", 1, 13),
    ("I'm a lightweight so I couldn't keep up with the tour tastings :D but it was enjoyable nonetheless. Jonathan was a good tour guide. I love how interactive and informative the tour was. Highly recommended.", 5, 0, "2017-07-18", 1, 12), 
    ("We had a very knowledgeable tour guide named Jonathan who gave a great tour. They had great beer, especially the White Wolf, without any preservatives  .", 5, 0, "2017-07-15", 1, 11),
    ("Super cool brewery tour!! Michael was our tour guide and he was super cool and fun. He made the tour very memorable. Got to sample some pretty bomb beer and I don't even like beer that much! 11/10 would recommend", 5, 0, "2018-03-21", 1, 12),
    ("One of the worst insurance companies ever. Underwriting department is horrible, they make mistakes with forms that they need from you and they have a bad attitude. Company also changes monthly premium every 6 months by a lot. Waste of time. Not interested in giving them my business.", 1, 5, "2018-07-24", 4, 17),
    ("Geico is awful. One of their policy holders drove through our fence and destroyed our custom built raised garden beds. It's been 8 weeks, and still no resolution. They called once or twice for a lowball offer ($700 for $5000 replacement value). Not only do I implore you to choose another insurance company, I don't wish this on my worst enemy.", 1, 3, "2018-09-04", 4, 5), 
    ("I have been a customer for over a year and words can't describe what this company does. They didn't bother to call me to let me know that my insuarance has cancelled. I only have 2 days to find a new policy. Watch out!", 1, 4, "2018-08-24", 4, 11),
    ("there is a reason why they give low rates cause its terrible coverage... had a claim with my car and they gave me the biggest hassle  made me feel like it's my fault or something,  they really need to clean house and hire some qualified people who actually want to help people in distress. The geico divison in southern California is complete garbage full of new hire amateurs please clean house!!!", 1, 8, "2018-07-31", 4, 19), 
    ("Cancelled my policy and never having an accident and they keep taking money out. No when i get a new car i wont be using their over priced insurance.", 1, 0, "2018-09-20", 4, 8),
    ("I only come to this location for a quick pick me up when I'm in the area. I do like the fact that each time I've came here, the workers are pretty fast at making my coffee. The staff is nice and have never messed my order up unlike some other locations.", 4, 0, "2017-09-24", 6, 14),
    ("Not much to say in this review except for the fact that every time I come here the baristas as always so friendly which is very appreciated.", 5, 2, "2017-02-05", 6, 20),
    ("The coffee is good. But what kind of coffee shop doesn't have a bathroom for paying customers? After buying a drink and asking where the bathroom was, I was told to go to a parking garage across the street and go up to the fourth floor to use their bathroom. You sell something that makes people poop and you don't have a bathroom? That's insanity.", 1, 0, "2017-09-14", 6, 5),
    ("My personally experience here wasn't the best, my drink was watered down, and the tapioca for my bubble tea was a little harden. But the people working here are friendly and there is a nice, decently quiet atmosphere. Good place to come to sit and chill while chatting away with friends.", 3, 0, "2014-06-20", 7, 13), 
    ("Unique korean pastries! Cool interior! Friendly service!", 5, 0, "2013-12-01", 7, 5),
    ("I love this place.  Great service and great food.  I only have one problem with this place- they don't offer organic tofu.  I've done lots of research and tofu that isn't organic is super unhealthy, so I wish they offered it.  Other than that- it's great!  And order the Tom Yum Soup- sooooo good!", 4, 0, "2018-11-24", 8, 2), 
    ("It's decent Thai food. Not the best service. If you live off melrose then i'd probably choose this one verse other options. If you want the best food & service in the area i'd say go to Savory Thai or Onnys. This place tends to get your mobile order wrong and they don't have the best service on the bar side of the restaurant. You tend to get neglected.", 3, 0, "2018-10-29", 8, 17),
    ("Great quick service food. Large filled burritos filled with stuff.  Late night filling food. Large variety of Mexican food.", 5, 0, "2018-10-12", 9, 10),
    ("Tasty, inexpensive, late night cuisine.  Varied menu for south of the border grub.  Rolled tacos were good.  A couple of others in my party enjoyed the carne asada fries.  Quick, service.  Primarily takeout, limited outdoor seating.", 4, 0, "2017-08-18", 9, 2),
    ("Not impressed at all.  Food was flavorless, plates were served topped off and that made everything mix together and gross appearance.", 1, 1, "2017-05-01", 9, 3),
    ("I love the Arizona Burrito, cowboy fries look good too, don't know what else to write", 5, 0, "2017-06-16", 9, 15),
    ("Placed a to go order here tonight, not only did it take abnormally long to get my food but forgot 2 of my items. So frustrating, will definitely not be back.", 1, 1, "2017-05-12", 9, 17),
    ("$5 for a bean and cheese burrito. AND it wasn't good! I was on the search for good Mexican fast food and this place is not it.", 1, 0, "2016-07-30", 9, 13),
    ("I came here for Summerlicious and tried the hush puppies (corn fritters), alligator stew (tasted like fish in spicy stew), and cajun seafood jambalaya (quite spicy) with collard greens. Desserts were meringue with fruits, Nawlins bread pudding, and mixed berries and kiwi.", 3, 0, "2018-10-04", 11, 5),
    ("Excellent service. Love the bar and the vibe. Oysters were terrific. Buck a shuck can't go wrong. We had the hush puppies and jambalaya too. Everything was very tasty and I can't wait to go back for the shrimp app, lamb main course and maybe a tarot reading too.", 5, 0, "2018-10-23", 11, 1),
    ("1st time here traveling in a semi we yelp fried zucchini and this spot came up. Food is cooked to order and in front of you. Food (burgers) are tasty, seasoned really good. Will come back...", 4, 0, "2018-11-28", 12, 10),
    ("I went to this place for a quick burger patty with cheese. They charged me almost 8 dollars! Why? Not even an option to order from the senior or lunch menu. I am really disappointed. I know a lot of people from my high school go here after the games. I will not be joining them.", 1, 0, "2018-11-26", 12, 20),
    ("Have been somewhat of a fan for years, however, tonight was definitely not a good night. 3 out of 4 of us have been sick for the past several hours. I hope whatever it is/was gets resolved before they start serving food to the paying public tomorrow. Sorry for the bad review guys but this is pretty serious.", 2, 1, "2018-05-04", 12, 12),
    ("The history of this Safeway with me was a long one. I really think it's an major upgrade from the past. Lots of choices of drink, fruits, food, snacks ,vegetables etc. There is always something here for the festive ,hungry and thirsty. The endless aisles of items makes this a true San Francisco Supermarket.", 5, 2, "2018-09-30", 14, 8),
    ("Don't use the ATM here. I withdrew cash and had my bank card skimmed and this is the only place besides my bank where I've withdrawn money. BEWARE", 1, 0, "2018-11-30", 14, 15),
    ("This is the worlds slowest Safeway. I don't understand how it takes 10 minutes to ring up 1 Apple. Please try and be more like Trader Joe's", 1, 1, "2018-07-03", 14, 13),
    ("This store is super awesome! It's really cheap and there are good finds! Most of stuff is urban but they also have other things too! Baby clothes are cheap! Wow! And the shoes!!", 4, 0, "2016-01-23", 16, 8),
    ("Did not the selection like the Oakland store. Could not find what I need and no one working there is aware of there products", 2, 0, "2015-05-05", 16, 19),
    ("Real sharks here, the two women that work here are very dishonest, I ask specific questions & they both deliberately lied to my face insisting the loan only would cost ___ amount come to find out the interest is OUT THE ROOF! DONT TRUST THIS PLACE!", 1, 2, "2017-01-31", 17, 18),
    ("This place is a RIP OFF and a MONEY PIT, you go to them for a Loan becaue you are in need for whatever reason. You end up paying TRIPLE of what your need was. NOT to mention each month you make a payemnt you are renewing YOUR contact. adding more interest on to your loan causing a more deeping Money PIT loop for you to NEVER get it Resolved. THIS PLACE IS A RIP OFF .. IT GETS 50 THUMBS DOWN RIPOFF.", 1, 2, "2013-11-17", 17, 12),
    ("Decent product. ..HORRIBLE service. Totally unprofessional.  Would NEVER spend one red cent here.  They almost ruined my wedding day....buyer beware!!!!", 1, 2, "2015-08-07", 18, 13),
    ("Andrew and the guys did an awesome job on our pavers and fire pit!!! They worked around my sleep schedule (night worker) and also Thanksgiving holiday. The price was reasonable and the work was top notch!!! Highly recommended and will use them for all future projects!!!", 5, 1, "2018-01-03", 19, 2),
    ("I don't usually write reviews, but Andrew and his team really saved my butt. Their work is exemplary and they were able to assist me with my emergency paver project in record time. My walkway looks very professional and is pleasant to look at. If/when I need paver work done again I will be hiring them.", 5, 0, "2018-06-13", 19, 35),
    ("Andrew and his crew showed up when scheduled, started demolition promptly, removed all refuse. Pavers and crew showed up as scheduled. Job was done beautifully and on time. Could not have asked for better!!", 5, 1, "2017-08-05", 19, 1),
    ("Great design sense, fast and very good installation! I had a few changes to my idea and they made them without an issue and it came out better than I ever would have thought. Thank you for a job well done! Oh and all that at a great price.", 5, 1, "2014-11-03", 19, 35),
    ("My husband and I come here a lot. The food is always perfect. Our usuals are cheeseburgers with fries and mozzarella sticks. There staff are always efficient and quick.", 5, 0, "2018-12-01", 20, 15),
    ("Outdoor table has no roof its hot as hell. I waited in line for 4 minutes untill someone sees me then take my order. This place look run down and poor", 2, 0, "2018-10-27", 20, 37),
    ("I know employees can't control it but it would be nice to see people working in there NOT SNEEZING ALL OVER THE PLACE. Absolutely disgusting, she (black lady) didn't even cover her mouth. I bought 5 burgers but I ended up tossing it. Kinda disgusting to think about eating someone's sneeze. Will not return. Came in around 5pm 12-5-18.", 1, 0, "2018-12-05", 20, 2),
    ("Customer service A1 food was piping hot and I have no complaints. We got baconzillas, fries and sodas everything was fresh. I will say the transients made me weary but other than that loved EVERYTHING. Thanks will return.", 5, 1, "2018-03-24", 20, 35),
    ("I had trouble understanding the specails and Ebony was very patient on explaining the menu options. The fries are seasoned and delicous! We got alot of food and dessert for under $20 . can't complain but only thank this place for being here!", 5, 0, "2018-11-07", 20, 35),
    ("Ben took me There for lunch today and it was awesome. Good service great food... Too much food LOL", 5, 0, "2018-11-06", 20, 7),
    ("Had a burger Jones and drove through because nobody can mess up a burger, right?  WRONG. Burgers don't taste fresh like the beef was frozen for months, cooked and froze again then warmed up in a microwave...gross", 2, 1, "2018-06-29", 20, 2),
    ("I just recently discover this place. Really great fries. These are seasoned fries. I eat them until I get sick. Literally. 4 large fries, 5 large fries.", 4, 1, "2017-06-12", 20, 19),
    ("This place is so disgusting and will never return. Got severe food poisoning. STAY AWAY", 1, 0, "2018-10-12", 20, 5),
    ("The cook named Raul made my order and charged me for it while everyone stood around. He even cared to ask me if I wanted ketchup and told me to have a good day. By far the kindest person at Rally's.", 5, 1, "2018-08-08", 20, 7),
    ("The food was cold and they didn't know what they were doing!! I'm so done with rally I will never go back this is my second time to different restaurants and it all sucked.", 1, 0, "2018-04-17", 20, 12),
    ("This an awesome spot for BBQ & the owners friendly & hospitable great place for an afternoon lunch will definitely comeback again!", 5, 0, "2018-09-15", 21, 3),
    ("100% authentic soul food.  Best greens I've ever had and this is the best BBQ in the whole Bay Area.  I don't think any other place has BBQ this good.  Plus the people who work there are so sweet and welcoming. Check it out people!  You can't go wrong!", 5, 0, "2018-09-14", 21, 25),
    ("OMG! I found the best bbq pork sandwich west of Georgia Pig! The prices are right at n and Mae a 4th generation carries on mamas recipes on to the next generation. Everything house made. Sauces, salads, side dishes. Everything. Looking forward to coming back and when is Christmas, smoked turkeys.  Heck ya. Ya'll come back now! I am", 5, 0, "2018-08-15", 21, 33),
    ("I heard about this spot from some locals so you better believe I braved traffic on Toronto's busiest day of the year (Canadian Expo) to grab a treat before my departing flight. I ordered the Reese's buttercup cake which is their version of a giant Reese's so come give it a try if chocolate and peanut butter is your thing.", 5, 0, "2018-09-11", 22, 2),
    ("The bread is amazing.  Must have..Place is very HOT.. so be prepared get in and out.", 5, 1, "2017-08-31", 22, 12), 
    ("As a French person living in Toronto, I give their croissants a big 5 stars. SO GOOD!!", 5, 0, "2018-03-27", 22, 25),
    ("Ordered the chocolate ganache and london fog. The tea was amazing!! Best london fog I have had so far. The ganache was delicious as well.", 4, 0, "2017-01-22", 22, 10),
    ("Great food. I love their salsa. I have been going to this place at least for fifteen years.", 5, 0, "2018-08-19", 23, 1),
    ("Ditto AM reviewer below. This place used to be an establishment, and it's gone totally down hill. No Senior menu, no fresh tortillas, and no service (waited 15 minutes for no water). There are no shortage of Mexican restaurants in town, so don't bother with this place. One star for chip guy who kept that salsa flowing.", 1, 0, "2018-08-31", 23, 7),
    ("I really haven't had anything bad from here.  The burritos are really good and so is the salsa.  Great service too.", 3, 2, "2016-12-28", 24, 7),
    ("Do NOT get any sort of security services with ADT!!!!! They tricked me into signing another 3 years just because I moved to another unit in my building!", 1, 1, "2018-11-26", 25, 7),
    ("HORRIBLE", 1, 1, "2018-10-31", 25, 19),
    ("This is probably my favorite breakfast spot. Whether you're looking for something quick on the go or a full on breakfast, you can't go wrong here. The owner is really nice and the service is great. Try the coffee mill combos!", 5, 0, "2018-10-11", 26, 26), 
    ("I had breakfast here my last day in Oakland and I'm sad it took me 6 days to find this beautiful place. The service comes fast and with amazing smiles. The food was hot & delicious and I can't thank the ladies enough for the great food & smiles.", 5, 0, "2018-09-06", 26, 37),
    ("Worst customer service ever. She mocked me bec I asked if a side of potatoes were 5$. This is only a good place to go if the owner likes you. It's one of those places that makes up prices on the spot...", 1, 1, "2018-04-16", 26, 37), 
    ("Friendly service but the coffee unfortunately is not very good. I got a cafe au lait that ended up being 95% 'au lait' and had to return to have more coffee added.", 2, 2, "2017-08-07", 26, 37), 
    ("Great place. Large breakfast menu, with large outdoor patio. Food is great American dinner fair. Service is excellent as well.", 5, 0, "2018-05-26", 26, 18), 
    ("Sitting here 10 minutes and still have no coffee. Service was poor. Not offered a decaf coffee refill. Food was ok, a tad skimpy for the price.", 2, 0, "2018-04-22", 26, 35), 
    ("Advertised as the 'oldest coffee place in Oakland'. The building IS old, and the interior also shows it. The place is clean, and kitchy... We ordered our coffees and headed out to stroll the town. Coffee was good...", 3, 0, "2018-02-04", 26, 32), 
    ("I ordered a vanilla latte, it was okay. I prefer my Starbucks, but this place was just conveniently located nearby.", 3, 0, "2017-07-05", 26, 5),   
    ("OK at best.", 2, 0, "2018-07-07", 28, 35),
    ("Great local pizza in Greenlawn... new owner is always friendly and expanding menu/giving us samples of new items. We typically get slices to go and there's always a variety, even later in the night.", 5, 1, "2017-02-21", 28, 10),
    ("Worst pizza in the area!!! Walk 100 yards north and do yourself a favor and eat at Campania. You wont regret it. Can only comment on slices and they taste like cardboard with some nasty sauce on it. Dont say I didn't warn you.", 1, 3, "2016-10-07", 28, 10),
    ("We're new to the area, and it took us a little while to pick a pizza place. This place hooked us with their generous specials, and the sicilian pizza really won us over. I cannot say that it's the best pizza I've ever had, but it's definitely a five-star value and it will keep us coming back.", 4, 1, "2016-02-03", 28, 5), 
    ("Went here for the first time Saturday.  Was told it's under new management.   Picked up a chicken Parmesan hero which was fantastic.  This will be my new Italian take out stop.", 5, 1, "2016-10-02", 28, 2),
    ("New owner is a real good guy, and his recipes are awesome. I tried the general tso's chicken. Naturally I was a little iffy but it was great with pepperoni garlic knots.", 5, 0, "2016-12-31", 28, 14), 
    ("Only has Sicilian Pizza here, but it is fantastic.  Better than Umberto's.  The only thing is pizza is only 8 slices, isn't a normal Sicilian 12 slices ???? Same price as Umberto's 12 slice Sicilian.", 4, 0, "2016-01-08", 28, 26),
    ("HORRIBLE.  CRUST tasteless, cheese tasteless.  Did you give us gluten free?  Could not eat any more. REALLY BAD!", 1, 0, "2015-11-14", 28, 35);
    

INSERT INTO photo (upload_date, caption, label, business_id, user_id) VALUES
    ("2018-08-18", "", "drink", 1, 1),
    ("2018-08-18", "", "inside", 1, 1),
    ("2018-08-18", "pizza", "food", 1, 1),
    ("2018-10-30", "", "inside", 1, 1),
    ("2018-10-30", "", "inside", 1, 1),
    ("2017-07-08", "", "menu", 2, 2),
    ("2017-07-08", "", "menu", 2, 2),
    ("2016-08-28", "", "food", 3, 8),
    ("2016-08-28", "", "food", 3, 8),
    ("2016-08-28", "", "food", 3, 8),
    ("2015-11-02", "", "food", 3, 15),
    ("2015-11-02", "", "food", 3, 15),
    ("2018-02-04", "", "outside", 6, 2),
    ("2018-03-16", "Chunky layer at bottom, tastes like sweet milk with chunks", "drink", 6, 4),
    ("2018-03-16", "Who liks chunky matcha drinks? Layers on top and bottom", "drink", 6, 4),
    ("2018-10-29", "Red curry", "food", 8, 17),
    ("2016-10-21", "Soboro bun, no filling. Taste just like pan dulce", "food", 7, 3),
    ("2018-08-29", "Chorizo burrito", "food", 9, 1),
    ("2018-08-29", "Chorizo special burrito", "food", 9, 1),
    ("2018-08-29", "Carne asada taco", "food", 9, 1),
    ("2018-11-28", "1st time here", "inside", 12, 20),
    ("2018-09-30", "check your health", "inside", 14, 8),
    ("2018-09-30", "refrigerated dog food", "food", 14, 8),
    ("2018-09-30", "yes !!!! beer", "drink", 14, 8),
    ("2016-01-23", "", "inside", 16, 8),
    ("2016-01-23", "", "inside", 16, 8),
    ("2016-01-23", "", "inside", 16, 8),
    ("2018-10-27", "No roof for outdoor table :/", "outside", 20, 37),
    ("2018-03-24", "yum", "food", 20, 35),
    ("2017-06-12", "", "food", 20, 19),
    ("2018-09-15", "afternoon lunch", "food", 21, 3),
    ("2018-09-11", "", "food", 22, 2), 
    ("2018-09-06", "The food was amazing", "food", 26, 37);

    
-- pain in the butt 
-- INSERT INTO review_contains_photo (review_id, photo_id) VALUES
--     (1,4),
--     (1,5),
--     (3,8),
--     (3,9),
--     (3,10),
--     (33,16),
--     (40,20),
--     (40,21),
--     (40,22),
--     (42, )

-- juan: added ("burger", 1) record to have multiple results from query

INSERT INTO category (name, business_id) VALUES
    ("brewery", 1),
    ("pizza", 1),
    ("burger", 1),
    ("caterer", 2),
    ("food truck", 2),
    ("barbeque", 2),
    ("bistro", 3),
    ("auto insurance", 4),
    ("automotive", 5),
    ("coffee", 6),
    ("tea", 6),
    ("bakery", 7),
    ("thai", 8),
    ("bar", 8),
    ("seafood", 8),
    ("mexican", 9),
    ("gift shop", 10),
    ("accessories", 10),
    ("toy store", 10),
    ("southern", 11),
    ("cajun", 11),
    ("soul food", 11),
    ("burger", 12), 
    ("bar", 12), 
    ("sandwich", 12),
    ("drugstore", 14),
    ("grocery", 14),
    ("department store", 16),
    ("bakery", 18),
    ("masonry", 19), 
    ("concrete", 19),
    ("burger", 20),
    ("fast food", 20),
    ("american", 21),
    ("barbeque", 21),
    ("bakery", 22),
    ("mexican", 23),
    ("mexican", 24),
    ("security system", 25),
    ("home automation", 25),
    ("coffee", 26),
    ("tea", 26), 
    ("bakery", 26), 
    ("breakfast", 26),
    ("brunch", 26),
    ("eyewear", 27),  
    ("pizza", 28);

    
INSERT INTO hour (day, open_time, close_time, business_id) VALUES
    ("tue", "11:00:00", "21:00:00", 1),
    ("wed", "11:00:00", "21:00:00", 1),
    ("thu", "11:00:00", "21:00:00", 1),
    ("fri", "11:00:00", "21:00:00", 1),
    ("sat", "11:00:00", "21:00:00", 1),
    ("mon", "9:00:00", "2:00:00", 3),
    ("tue", "9:00:00", "2:00:00", 3),
    ("wed", "9:00:00", "2:00:00", 3),
    ("thu", "9:00:00", "2:00:00", 3),
    ("fri", "9:00:00", "2:00:00", 3),
    ("sat", "17:00:00", "2:00:00", 3),
    ("sun", "10:00:00", "20:00:00", 3),
    ("mon", "7:30:00", "17:30:00", 5),
    ("tue", "7:30:00", "17:30:00", 5),
    ("wed", "7:30:00", "17:30:00", 5),
    ("thu", "7:30:00", "17:30:00", 5),
    ("fri", "7:30:00", "17:30:00", 5),
    ("mon", "5:30:00", "20:00:00", 6),
    ("tue", "5:30:00", "20:00:00", 6),
    ("wed", "5:30:00", "20:00:00", 6),
    ("thu", "5:30:00", "20:00:00", 6),
    ("fri", "5:30:00", "20:00:00", 6),
    ("sat", "5:30:00", "20:00:00", 6),
    ("sun", "5:30:00", "20:00:00", 6),
    ("mon", "11:00:00", "21:30:00", 8),
    ("tue", "11:00:00", "21:30:00", 8),
    ("wed", "11:00:00", "21:30:00", 8),
    ("thu", "11:00:00", "21:30:00", 8),
    ("fri", "11:00:00", "22:00:00", 8),
    ("sat", "11:00:00", "22:00:00", 8),
    ("sun", "11:00:00", "21:00:00", 8),
    ("mon", "00:00:00", "23:59:59", 9),
    ("tue", "00:00:00", "23:59:59", 9),
    ("wed", "00:00:00", "23:59:59", 9),
    ("thu", "00:00:00", "23:59:59", 9),
    ("fri", "00:00:00", "23:59:59", 9),
    ("sat", "00:00:00", "23:59:59", 9),
    ("sun", "00:00:00", "23:59:59", 9),
    ("mon", "09:00:00", "18:00:00", 10),
    ("tue", "09:00:00", "18:00:00", 10),
    ("wed", "09:00:00", "18:00:00", 10),
    ("thu", "09:00:00", "18:00:00", 10),
    ("fri", "09:00:00", "17:00:00", 10),
    ("sat", "10:00:00", "17:00:00", 10),
    ("mon", "16:00:00", "23:00:00", 11),
    ("tue", "16:00:00", "23:00:00", 11),
    ("wed", "16:00:00", "23:00:00", 11),
    ("thu", "16:00:00", "23:00:00", 11),
    ("fri", "16:00:00", "00:00:00", 11),
    ("sat", "16:00:00", "00:00:00", 11),
    ("sun", "16:00:00", "22:00:00", 11),
    ("mon", "11:00:00", "22:00:00", 12),
    ("tue", "11:00:00", "22:00:00", 12),
    ("wed", "11:00:00", "22:00:00", 12),
    ("thu", "11:00:00", "22:00:00", 12),
    ("fri", "11:00:00", "23:00:00", 12),
    ("sat", "11:00:00", "22:00:00", 12),
    ("sun", "11:00:00", "19:00:00", 12),
    ("mon", "6:00:00", "00:00:00", 14),
    ("tue", "6:00:00", "00:00:00", 14),
    ("wed", "6:00:00", "00:00:00", 14),
    ("thu", "6:00:00", "00:00:00", 14),
    ("fri", "6:00:00", "00:00:00", 14),
    ("sat", "6:00:00", "00:00:00", 14),
    ("sun", "6:00:00", "00:00:00", 14),
    ("mon", "10:00:00", "19:00:00", 17),
    ("tue", "10:00:00", "18:00:00", 17),
    ("wed", "10:00:00", "18:00:00", 17),
    ("thu", "10:00:00", "18:00:00", 17),
    ("fri", "10:00:00", "19:00:00", 17),
    ("sat", "9:00:00", "16:00:00", 17),
    ("mon", "9:00:00", "2:00:00", 20),
    ("tue", "9:00:00", "2:00:00", 20),
    ("wed", "9:00:00", "2:00:00", 20),
    ("thu", "9:00:00", "2:00:00", 20),
    ("fri", "9:00:00", "3:00:00", 20),
    ("sat", "9:00:00", "3:00:00", 20),
    ("sun", "9:00:00", "2:00:00", 20), 
    ("tue", "11:00:00", "22:00:00", 21), 
    ("wed", "11:00:00", "22:00:00", 21), 
    ("thu", "11:00:00", "22:00:00", 21), 
    ("fri", "11:00:00", "22:00:00", 21), 
    ("sat", "11:00:00", "22:00:00", 21), 
    ("sun", "11:00:00", "22:00:00", 21),
    ("mon", "7:30:00", "19:30:00", 22),
    ("tue", "7:30:00", "19:30:00", 22),
    ("wed", "7:30:00", "19:30:00", 22),
    ("thu", "7:30:00", "19:30:00", 22),
    ("fri", "7:30:00", "19:30:00", 22),
    ("sat", "9:00:00", "18:00:00", 22),
    ("sun", "9:00:00", "18:00:00", 22),
    ("mon", "00:00:00", "23:59:59", 25),
    ("tue", "00:00:00", "23:59:59", 25),
    ("wed", "00:00:00", "23:59:59", 25),
    ("thu", "00:00:00", "23:59:59", 25),
    ("fri", "00:00:00", "23:59:59", 25),
    ("sat", "00:00:00", "23:59:59", 25),
    ("sun", "00:00:00", "23:59:59", 25),    
    ("mon", "07:00:00", "15:00:0", 26),
    ("tue", "07:00:00", "15:00:0", 26),
    ("wed", "07:00:00", "15:00:0", 26),
    ("thu", "07:00:00", "15:00:0", 26),
    ("fri", "07:00:00", "15:00:0", 26),
    ("sat", "07:00:00", "15:00:0", 26),
    ("sun", "07:00:00", "15:00:0", 26),
    ("mon", "09:00:00", "22:00:0", 28),
    ("tue", "09:00:00", "22:00:0", 28),
    ("wed", "09:00:00", "22:00:0", 28),
    ("thu", "09:00:00", "22:00:0", 28),
    ("fri", "09:00:00", "23:00:0", 28),
    ("sat", "09:00:00", "23:00:0", 28),
    ("sun", "09:00:00", "21:30:0", 28);

    

-- SELECT QUERYS --
-- get the count of reviews per user

-- ** target list in SELECT must be a subset of the grouping list in GROUP BY **

SELECT user.user_id AS "id", 
        user.name, 
        COUNT(review.review_id) AS "review count", 
        CONCAT(
            user.name, 
            " has written ", 
            COUNT(review_id), 
            CASE
                WHEN COUNT(*) = 1 THEN " review"
                ELSE " reviews"
            END) 
        AS "user review count"
FROM user
LEFT JOIN review
    ON review.user_id = user.user_id
GROUP BY user.name;

-- get the average rating per business, number of reviews per business
SELECT business.business_id AS "id", business.name AS "company name", FORMAT(IFNULL(AVG(review.rating),0),1) AS "average rating", COUNT(review.rating) AS "# of reviews"
FROM business
LEFT JOIN review
    ON review.business_id = business.business_id
GROUP BY business.business_id;

-- practice using view
SELECT * FROM business_name_and_state;

-- get business's that are in the following state
SELECT business_id AS "id", name AS "companies in CA, NV, OR WA", 
        CONCAT(address, " ", city, ", ", state, " ", postal_code) AS "location"
FROM business
WHERE state IN ("CA", "NV", "WA");

-- get companies that have no reviews
SELECT business_id AS "id", name AS "companies with no reviews"
FROM business
WHERE NOT EXISTS (SELECT * 
                  FROM review
                  WHERE review.business_id = business.business_id);

-- get companies that are open more than 5 days/week
SELECT business.business_id AS "id", business.name AS "companies open more than 5 days a week", COUNT(*) AS "days open"
FROM business
INNER JOIN hour
    ON hour.business_id = business.business_id
GROUP BY business.name
HAVING COUNT(hour.day) > 5;

-- get companies that are open sat OR sun
SELECT DISTINCT business.business_id AS "id", business.name AS "companies open Sat OR Sun"
FROM business
INNER JOIN hour
    ON hour.business_id = business.business_id
WHERE hour.day IN ("sat", "sun");

-- get companies that are open sat AND sun
SELECT business.business_id AS "id", business.name AS"companies open Sat AND Sun"
FROM business
INNER JOIN hour
    ON hour.business_id = business.business_id
WHERE hour.day = "sat" AND EXISTS (SELECT *
								   FROM hour
								   WHERE hour.day = "sun"
								   AND business.business_id = hour.business_id);


-- get list of users that have written a review for at least 3 different businesses
SELECT U.name, COUNT(*) AS "review count"
FROM user U, review R
WHERE U.user_id = R.user_id
GROUP BY R.user_id, U.name
HAVING COUNT(*) > 3;


-- get the user name with the most helpful votes
SELECT U.name, U.helpful
FROM user U
WHERE U.helpful >= ALL (SELECT U2.helpful
                        FROM user U2);
                        
-- get businesses that are ONLY open on weekdays, monday-friday
-- might be over-complicated
EXPLAIN SELECT *
FROM business B
WHERE B.business_id IN (SELECT H.business_id
					    FROM hour H
						WHERE H.business_id NOT IN (SELECT DISTINCT(H2.business_id)
													FROM hour H2
													WHERE H2.day = "sat" OR
													      H2.day = "sun"));

-- get all businesses that are categorized by "burger"
SELECT *, C.name AS "category"
FROM business B, category C
WHERE B.business_id = C.business_id AND
      C.name LIKE "%burger%";
      
-- show index(es) on hour table
SHOW INDEXES FROM hour;

-- drop the database when done using it
-- DROP DATABASE csc_675;