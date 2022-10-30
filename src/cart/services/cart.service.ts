import { Injectable } from '@nestjs/common';
import { Cart, CartItem, Product } from '../models';

import { Client } from 'pg';
import { DB_OPTIONS } from 'src/constants';
import axios from 'axios';
import moment from 'moment';
@Injectable()
export class CartService {
  async findByUserId(userId: string): Promise<Cart> {
    const client = new Client(DB_OPTIONS);
    try {
      await client.connect();
      const cart = await client.query(`
      select id, product_id, count from carts
  	  inner join cart_items
  	  on carts.id = cart_items.cart_id
      where cart_id = '${userId}'
      `);
      const products: CartItem[] = await Promise.all(
        cart.rows.map(async row => {
          return {
            product: (
              await axios.get(
                `https://skx597wlr6.execute-api.eu-west-1.amazonaws.com/dev/products/${row.product_id}`,
              )
            ).data as Product,
            count: row.count as number,
          } as CartItem;
        }),
      );
      return {
        items: products,
        id: userId,
      };
    } catch (err) {
      console.log('findByUserId:', err);
    } finally {
      client.end();
    }
  }
  async createByUserId(userId: string) {
    const client = new Client(DB_OPTIONS);
    try {
      client.connect();
      await client.query(`
      insert into carts (id, created_at, updated_at) values
      (
        '${userId}', '${moment().format('YYYY-MM-DD')}',
        '${moment().format('YYYY-MM-DD')}' 
      )
      `);

      const userCart = {
        id: userId,
        items: [],
      };

      return userCart;
    } catch (err) {
      console.log(err);
      return undefined;
    } finally {
      client.end();
    }
  }
  async findOrCreateByUserId(userId: string): Promise<Cart> {
    const userCart = await this.findByUserId(userId);

    if (userCart) {
      return userCart;
    }

    return await this.createByUserId(userId);
  }

  async updateByUserId(userId: string, { items }: any): Promise<any> {
    console.log(items);
    const { id, ...rest } = await this.findOrCreateByUserId(userId);
    const client = new Client(DB_OPTIONS);

    const deletedOnes = rest.items.filter(
      dbItem =>
        items.findIndex(newItem => newItem.product.id === dbItem.product.id) ===
        -1,
    );

    const updateQuery = `
    INSERT into cart_items (cart_id, product_id, count) values
    (
      ${items.map(i => `'${id}', '${i.product.id}', ${i.count}`).join(',')}
    )
      ON CONFLICT (product_id) DO UPDATE 
        SET count = excluded.count;
    `;
    console.log(updateQuery);
    try {
      await client.connect();
      let result = await client.query(updateQuery);
      if (result && deletedOnes.length) {
        result = await client.query(
          `DELETE FROM cart_items WHERE product_id IN (${deletedOnes
            .map(v => `'${v.product.id}'`)
            .join(',')});`,
        );
      }
      if (result) {
        const query = `
        UPDATE carts
        SET updated_at = '${moment().format('YYYY-MM-DD')}'
        WHERE carts.id = '${id}';
        `;
        await client.query(query);
      }
      console.log('r', result);
      return await this.findOrCreateByUserId(userId);
    } catch (err) {
      console.log(err);
    } finally {
      client.end();
    }
  }

  async removeByUserId(userId): Promise<void> {
    const client = new Client(DB_OPTIONS);
    try {
      await client.connect();
      await client.query(`
      DELETE FROM carts WHERE carts.id = '${userId}';
      `);
    } catch (err) {
      console.log(err);
    } finally {
      client.end();
    }
  }
}
