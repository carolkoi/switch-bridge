<template>
    <div class="box box-primary">
        <div class="box-body">
            <h1 class="pull-right">
                <button class="btn btn-primary pull-right" style="margin-top: -10px;margin-bottom: 5px" @click="saveReorderItems()">Request</button>
            </h1>
            <div id="dataTableBuilder_filter" class="dataTables_filter"><label>Search:<input type="search" v-model="searchQuery" class="form-control input-sm pull-left" placeholder="" aria-controls="dataTableBuilder"></label></div>

            <div class="row">
                <div class="col-md-12">

                    <table v-if="items.length" class="table table-responsive table-striped table-bordered">
                        <thead>
                        <tr>
                            <th>Partner</th>
                            <th>TXN Date</th>
                            <th>Paid Date</th>
                            <th>TXN Status</th>
                            <th>TXN Type</th>
                            <th>Primary Txn Ref</th>
                            <th>Sync Msg Ref</th>
                            <th>TXN No</th>
                            <th>Amount Sent</th>
                            <th>Rcver Cur</th>
                            <th>Amount Received</th>
<!--                            <th>Sender Currency Code</th>-->
                            <th>Sender</th>
                            <th>Receiver</th>
                            <th>Receiver Acc/No </th>
                            <th>Response</th>
                            <th>Receiver Bank </th>
                            <th>Action</th>

                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="item in resultQuery">
                            <td>{{ item.req_field123  }}</td>
                            <td>{{ item.req_field7  }}</td>
                            <td>{{item.date_time_added}}</td>
                            <td>item.paid_out_date</td>
                            <td>{{ item.res_field48 }}</td>
                            <td>{{ item.req_field41 }}</td>
                            <td>{{ item.req_field34 }}</td>
                            <td>{{item.sync_message ? item.sync_message : "N/A" }}</td>

                            <td>{{ item.req_field37 }}</td>
                            <td>{{ item.req_field49}}{{intval(item.req_field4)/100 }}</td>
                            <td>{{item.req_field50}}</td>
                            <td>{{intval(item.req_field5)/100  }}</td>
                            <td>{{ item.req_field3 }}</td>
                            <td>{{ item.req_field105  }}</td>
                            <td>{{ item.req_field108   }}</td>
                            <td>{{ item.req_field102  }}</td>
                            <td>{!! item.res_field44 !!} </td>
                            <td>{{ item.req_field112 }}</td>
                            <td>@include('transactions.datatables_actions')</td>

                        </tr>
                        </tbody>

                    </table>
                    <!--                    <h2>-->
                    <!--                        Derived output-->
                    <!--                    </h2>-->
                    <!--                    <pre>{{statusArr}}</pre>-->
                    <!--            <pre>{{qtyOrderedArr}}</pre>-->


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
        data() {
            return {
                errors: [],
                items: [],
                selectedItems: [],
                status: null,
                qty_ordered: null,
                stock_link: null,
                links: {},
                api: '/view-all-transactions',
                meta: {},
                index : 1,
                searchQuery: null,
            }
        },
        computed: {
            statusArr() {
                return this.selectedItems;
            },
            resultQuery(){
                if(this.searchQuery){
                    return this.items.filter((item)=>{
                        return this.searchQuery.toLowerCase().split(' ').every(v => item.description.toLowerCase().includes(v))
                    })
                }else{
                    return this.items;
                }
            }
        },

        methods: {
            getReorderItems(api) {

                axios.get(api).then(response => {
                    this.items = response.data.data;
                    this.links = response.data.links;
                    this.meta = response.data.meta;
                }).catch(err => {
                    console.log(err)
                })
            },
            fetchItems() {
                this.getReorderItems(this.api);
            },
            addReorderItem(item) {
                this.selectedItems.push(item)
                console.log(item)

            },
            updateOrderItem(item, value) {

                this.selectedItems = _.map(this.selectedItems, selectedItem => {
                    if (selectedItem.stock_link === item.stock_link) {
                        selectedItem.qty_ordered = value;
                    }
                    console.log(selectedItem)
                    return selectedItem;
                });

            },
            saveReorderItems(){
                let uri = '/item/reorders';
                // return console.log(this.selectedItems);
                axios.post('/save-reorder-items',this.selectedItems).then((response)=>{

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
