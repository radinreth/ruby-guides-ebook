# Active Record Basics

[Original source](http://edgeguides.rubyonrails.org/active_record_basics.html)

This guide is an introduction to Active Record.
After reading this guide, you will know:

+ What Object Relational Mapping and Active Record are and how they are used in Rails.
+ How Active Record fits into the Model-View-Controller paradigm.
+ How to use Active Record models to manipulate data stored in a relational database.
+ Active Record schema naming conventions.
+ The concepts of database migrations, validations and callbacks.

# 1 What is Active Record?

Active Record is the M in [MVC](http://edgeguides.rubyonrails.org/getting_started.html#the-mvc-architecture) - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database. It is an implementation of the Active Record pattern which itself is a description of an Object Relational Mapping system.

## 1.1 The Active Record Pattern

[Active Record was described by Martin Fowler](http://www.martinfowler.com/eaaCatalog/activeRecord.html) in his book *Patterns of Enterprise Application Architecture*. In Active Record, objects carry both persistent data and behavior which operates on that data. Active Record takes the opinion that ensuring data access logic as part of the object will educate users of that object on how to write to and read from the database.

## 1.2 Object Relational Mapping

Object-Relational Mapping, commonly referred to as its abbreviation ORM, is a technique that connects the rich objects of an application to tables in a relational database management system. Using ORM, the properties and relationships of the objects in an application can be easily stored and retrieved from a database without writing SQL statements directly and with less overall database access code.

## 1.3 Active Record as an ORM Framework

Active Record gives us several mechanisms, the most important being the ability to:

+ Represent models and their data.
+ Represent associations between these models.
+ Represent inheritance hierarchies through related models.
+ Validate models before they get persisted to the database.
+ Perform database operations in an object-oriented fashion.

# 2 Convention over Configuration in Active Record

When writing applications using other programming languages or frameworks, it may be necessary to write a lot of configuration code. This is particularly true for ORM frameworks in general. However, if you follow the conventions adopted by Rails, you'll need to write very little configuration (in some cases no configuration at all) when creating Active Record models. The idea is that if you configure your applications in the very same way most of the time then this should be the default way. Thus, explicit configuration would be needed only in those cases where you can't follow the standard convention.

## 2.1 Naming Conventions

By default, Active Record uses some naming conventions to find out how the mapping between models and database tables should be created. Rails will pluralize your class names to find the respective database table. So, for a class Book, you should have a database table called books. The Rails pluralization mechanisms are very powerful, being capable to pluralize (and singularize) both regular and irregular words. When using class names composed of two or more words, the model class name should follow the Ruby conventions, using the CamelCase form, while the table name must contain the words separated by underscores. Examples:

+ Database Table - Plural with underscores separating words (e.g., book_clubs).
+ Model Class - Singular with the first letter of each word capitalized (e.g., BookClub).

| Model / Class | Table / Schema |
| ------------- | -------------- | 
| Article       | articles       | 
| LineItem      | line_items     | 
| Deer          | deers          | 
| Mouse         | mice           |
| Person        | people         |

## 2.2 Schema Conventions

Active Record uses naming conventions for the columns in database tables, depending on the purpose of these columns.

+ **Foreign keys** - These fields should be named following the pattern *singularized_table_name_id (e.g., item_id, order_id)*. These are the fields that Active Record will look for when you create associations between your models.
+ **Primary keys** - By default, Active Record will use an integer column named id as the table's primary key. When using [Active Record Migrations](http://edgeguides.rubyonrails.org/migrations.html) to create your tables, this column will be automatically created.

There are also some optional column names that will add additional features to Active Record instances:

+ *created_at* - Automatically gets set to the current date and time when the record is first created.
+ *updated_at* - Automatically gets set to the current date and time whenever the record is updated.
+ *lock_version* - Adds [optimistic locking](http://api.rubyonrails.org/classes/ActiveRecord/Locking.html) to a model.
+ *type* - Specifies that the model uses [Single Table Inheritance](http://api.rubyonrails.org/classes/ActiveRecord/Base.html#class-ActiveRecord::Base-label-Single+table+inheritance).
+ *(association_name)_type* - Stores the type for [polymorphic associations](http://edgeguides.rubyonrails.org/association_basics.html#polymorphic-associations).
+ *(table_name)_count* - Used to cache the number of belonging objects on associations. For example, a *comments_count* column in a *Articles* class that has many instances of *Comment* will cache the number of existent comments for each article.

**Note:** While these column names are optional, they are in fact reserved by Active Record. Steer clear of reserved keywords unless you want the extra functionality. For example, type is a reserved keyword used to designate a table using Single Table Inheritance (STI). If you are not using STI, try an analogous keyword like "context", that may still accurately describe the data you are modeling.

# 3 Creating Active Record Models

It is very easy to create Active Record models. All you have to do is to subclass the ActiveRecord::Base class and you're good to go:
```ruby
class Product < ActiveRecord::Base
end
```

This will create a Product model, mapped to a products table at the database. By doing this you'll also have the ability to map the columns of each row in that table with the attributes of the instances of your model. Suppose that the products table was created using an SQL sentence like:
```sql
CREATE TABLE products (
   id int(11) NOT NULL auto_increment,
   name varchar(255),
   PRIMARY KEY  (id)
);
```

Following the table schema above, you would be able to write code like the following:
```ruby
p = Product.new
p.name = "Some Book"
puts p.name # "Some Book"
```

# 4 Overriding the Naming Conventions