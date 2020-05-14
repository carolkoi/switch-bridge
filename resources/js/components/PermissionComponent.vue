<template>
    <div class="box box-primary">
        <div class="box-body">
            <h1 class="pull-right">
                <button class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" @click="assignPermission()">Assign Permissions</button>
            </h1>
            <div id="dataTableBuilder_filter" class="dataTables_filter">
                <label>Search:<input type="search" v-model="searchQuery"
                                     class="form-control input-sm pull-left"
                                     placeholder="" aria-controls="dataTableBuilder"></label>
                <!-- Check All -->
            </div>

            <div class="row">
                <div class="col-md-12">
<!--                    <div class="pull-left">-->
<!--                        <input type='checkbox' @click='checkAll()' v-model='isCheckAll'> Check All Permissions-->

<!--                    </div>-->
<!--                    <br/>-->


                    <table v-if="permissions.length" class="table table-responsive table-striped table-bordered">
                        <thead>
                        <th>Select</th>
                        <th>Name</th>
                        <th>Description</th>
<!--                        <th>Role Assigned</th>-->
                        </thead>
                        <tbody>
                        <tr v-for="(permission) in resultQuery">
                            <td><input type="checkbox" @change="addPermission(permission)"
                                       :checked="isChecked(permission.roles)"
                                       ></td>
                            <td>{{permission.name}}</td>
                            <td><span v-html='permission.description'></span></td>
<!--                            <td>{{permission.roles}}</td>-->
<!--                            <td>{{getRoles(permission.roles)}}</td>-->
                        </tr>
                        </tbody>

                    </table>
<!--                                        <h2>-->
<!--                                            Derived output-->
<!--                                        </h2>-->
<!--                                        <pre>{{statusArr}}</pre>-->
<!--                    <pre>{{permissionsArr}}</pre>-->


<!--                    <div class="dataTables_paginate paging_simple_numbers" id="dataTableBuilder_paginate">-->
<!--                        <ul class="pagination">-->
<!--                            <li class="paginate_button previous pointed" id="dataTableBuilder_previous"><a-->
<!--                                @click="getAllPermissions(links.prev)">Previous</a>-->
<!--                            </li>-->
<!--                            <li class="paginate_button active"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="1"-->
<!--                                                                  tabindex="0">{{meta.current_page}}</a></li>-->
<!--                            <li class="paginate_button next pointed" id="dataTableBuilder_next"><a-->
<!--                                @click="getAllPermissions(links.next)">Next</a>-->
<!--                            </li>-->
<!--                        </ul>-->
<!--                    </div>-->
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
                // selectedPermissions: [{id:'',name:'', guard_name:'',description:'', roles:[]}],
                status: null,
                qty_ordered: null,
                stock_link: null,
                links: {},
                api: '/assign-permission',
                role_per_api: '/role-has-permission',
                meta: {},
                index : 1,
                searchQuery: null,
                isCheckAll: false,
                assignedPerm: []
            }
        },
        computed: {

            statusArr() {
                return this.selectedPermissions;
            },
            permissionsArr() {
                return this.permissions;
            },
            resultQuery() {
                if (this.searchQuery) {
                    return this.permissions.filter((permission) => {
                        return this.searchQuery.toLowerCase().split(' ').every(v => permission.name.toLowerCase().includes(v))
                    })
                } else {
                    return this.permissions;
                }
            },
        },

        methods: {
            getAllPermissions(api) {

                axios.get(api).then(response => {
                    this.permissions = response.data.data;
                    this.links = response.data.links;
                    this.meta = response.data.meta;
                    // console.log(this.permissions, this.data)

                }).catch(err => {
                    console.log(err)
                })
            },
            fetchItems() {
                this.getAllPermissions(this.api);
            },
            addPermission(permission) {
                let index = this.selectedPermissions.indexOf(permission);
                if (index >= 0)
                    this.selectedPermissions.splice(index, 1)
                else
                        this.selectedPermissions.push(permission);

            },
                // this.selectedPermissions.push(permission)
                // console.log(item)

            assignPermission(){
                // alert(this.permissions);
                let uri = '/members/roles';
                axios.post('/assign-permissions/' + this.data,this.selectedPermissions).then((response)=>{

                    console.log(response);

                }).catch(err => {
                    console.log(err)
                });
                return window.location = uri;
            },
            isChecked(roles) {
                return roles.includes(this.data)
            },
            getRoles: function(roles) {
                let rolesString = '';

                roles.forEach((role, index) => {
                        rolesString += ', ';
                    rolesString = rolesString + role.name
                });
                return rolesString
            },
            // checkAll: function(){
            //
            //     this.isCheckAll = !this.isCheckAll;
            //     this.assignedPerm = [];
            //     if(this.isCheckAll){ // Check all
            //         for (var key in this.permissions) {
            //             this.assignedPerm.push(this.permissions[key]);
            //         }
            //     }
            // },
        },
        created() {
            this.fetchItems();
        }
    };
</script>
