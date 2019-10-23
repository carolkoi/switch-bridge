
## About Wiz-Kit 

Wiz-kit is a development-kit based on the <a href='https://adminlte.io/'>AdminLTE </a>dashboard and <a href='http://labs.infyom.com/laravelgenerator/'>InfyOm CRUD Generator</a>
1. The kit will reduces the development time by 20-30%.
2. It makes code generation is a breeze.
3. Generate an entire CRUD operation in seconds.

## What can Wiz-Kit  do? 
1. Code generation.


## Installation.
1. ` git clone https://github.com/wizag-ke/WizKit.git.`
2. ` cd WizKit`
3. ` composer install`
4. ` cp .env.example .env` or for windows
5. ` copy .env.example .env`
6. `php artisan key:generate`

## Code generation
1. To generate an entire crude operation e.g for Events run
`php artisan infyom:scaffold Events --views=index,create,edit,show`