


#Model_T: Create easy Codeigniter model from mysql table

##What this do

Bored creating thousand of codeigniter model files coping field ( column )  name from mysql tables to get a complete list of php variables ?

ORM libraries and similar tools are so heavy and you dont want to use it ?

The easyest way to have initial file to begin develop you model having basic structure, main codeigniter model method, basic Active record query with basic where condition for update and select ?

###The answer is Model_T.

##Usage example and explanation
Let me do a fast example:

####First download model_T
git clone https://github.com/fborraccetti/Model_T.git

####Then 
* cd Model_T
* edit config.sh and setup database username and password

#### We have a Mysql Table like this:
Table name: test_table

Field Type Null Key Default Extra
field1 varchar(22) NO NULL
field2 int(11) NO NULL
field3 int(11) NO NULL
field4 date NO NULL

####Run the script
* ./model_T.sh test_table
* enjoi you new file test_table_m.php

####Look inside the file

* we have class declaration <?php class test_table_m extends CI_Model {
* variable declaration of each table field:         
		var $field1;
        var $field2;
        var $field3;
        var $field4;

* function set(){ with Active Record query
* function get(){
	* with prepared where condidion for each field
          if(isset($this->field1)){
              $this->db->where("field1",$this->field1);
              
* function update(){
	* with prepared where condidion for each field
          if(isset($this->field1)){
              $this->db->where("field1",$this->field1);

Copy table_test_m.php in your model directory and begin develop!




Credits
========
Initially Developed by Stefano Cherchi, thanks for main ideas and first script file. 


