<template>
    <div class="box box-primary">
        <div class="box-body">
            <h1 class="pull-right">
                <button class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" @click="assignPermission()">Assign Role</button>
            </h1>
            <div id="dataTableBuilder_filter" class="dataTables_filter"><label>Search:<input type="search" v-model="searchQuery" class="form-control input-sm pull-left" placeholder="" aria-controls="dataTableBuilder"></label></div>

            <div class="row">
                <div class="col-md-12">

                    <table v-if="permissions.length" class="table table-responsive table-striped table-bordered">
                        <thead>
                        <th>Select</th>
                        <th>Name</th>
                        <th>Description</th>
                        </thead>
                        <tbody>
                        <tr v-for="permission in resultQuery">
                            <td><input type="checkbox" @change="addPermission(permission)"></td>
                            <td>{{permission.name}}</td>
                            <td><span v-html='permission.description'></span></td>
                        </tr>
                        </tbody>

                    </table>
<!--                                        <h2>-->
<!--                                            Derived output-->
<!--                                        </h2>-->
<!--                                        <pre>{{statusArr}}</pre>-->


                    <div class="dataTables_paginate paging_simple_numbers" id="dataTableBuilder_paginate">
                        <ul class="pagination">
                            <li class="paginate_button previous pointed" id="dataTableBuilder_previous"><a
                                @click="getReorderItems(links.prev)">Previous</a>
                            </li>
                            <li class="paginate_button active"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="1"
                                                                  tabindex="0">{{meta.current_page}}</a></li>
                            <li class="paginate_button next pointed" id="dataTableBuilder_next"><a
                                @click="getReorderItems(links.next)">Next</a>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>

<script>
    export default {
        props:['data'],
        data() {
            return {
                errors: [],
                permissions: [],
                selectedPermissions: [],
                status: null,
                qty_ordered: null,
                stock_link: null,
                links: {},
                api: '/assign-permission',
                meta: {},
                index : 1,
                searchQuery: null,
            }
        },
        computed: {
            statusArr() {
                return this.selectedPermissions;
            },
            resultQuery(){
                if(this.searchQuery){
                    return this.permissions.filter((permission)=>{
                        return this.searchQuery.toLowerCase().split(' ').every(v => permission.name.toLowerCase().includes(v))
                    })
                }else{
                    return this.permissions;
                }
            }
        },

        methods: {
            getAllPermissions(api) {

                axios.get(api).then(response => {
                    this.permissions = response.data.data;
                    this.links = response.data.links;
                    this.meta = response.data.meta;
                }).catch(err => {
                    console.log(err)
                })
            },
            fetchItems() {
                this.getAllPermissions(this.api);
            },
            addPermission(permission) {
                this.selectedPermissions.push(permission)
                // console.log(item)

            },
            assignPermission(){
                // alert(this.selectedPermissions);
                // return console.log(this.selectedPermissions);
                let uri = '/roles';
                axios.post('/assign-permissions/' + this.data,this.selectedPermissions).then((response)=>{

                    console.log(response);

                }).catch(err => {
                    console.log(err)
                })
                return window.location = uri;
            }
        },
        created() {
            this.fetchItems();
        }
    };
</script>
